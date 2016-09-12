//
//  TimeRecordDetailViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

enum optionIdentifier: String {
    case Semester = "SemesterCell"
    case Course = "CourseCell"
    case Category = "CategoryCell"
    case Assignment = "AssignmentCell"
}

class TimeRecordDetailViewController: DetailViewController {
    
    // MARK: IBOutlets and Properties
    
    @IBOutlet weak var selectedSemesterCell: UITableViewCell!
    @IBOutlet weak var selectedSemesterTitle: UILabel!
    
    @IBOutlet weak var selectedCourseCell: UITableViewCell!
    @IBOutlet weak var selectedCourseTitle: UILabel!
    
    @IBOutlet weak var selectedCategoryCell: UITableViewCell!
    @IBOutlet weak var selectedCategoryTitle: UILabel!
    
    @IBOutlet weak var selectedAssignmentCell: UITableViewCell!
    @IBOutlet weak var selectedAssignmentTitle: UILabel!
    
    @IBOutlet weak var startTimePickerCell: UITableViewCell!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var startTimeLabel: UILabel!
    var startTimePickerIsHidden = true
    
    @IBOutlet weak var endTimePickerCell: UITableViewCell!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var endTimeLabel: UILabel!
    var endTimePickerIsHidden = true
    
    var timeRecordToEdit: TimeRecord?
    
    var selectedSemester: Semester!
    var selectedCourse: Course?
    var selectedCategory: Category?
    var selectedAssignment: Assignment?
    
    var timeRecordStartTime: NSDate!
    var timeRecordEndTime: NSDate!
    
    // MARK: Initialization
    
    // "base" means deepest option defined
    func configureOptions(baseOption: NSManagedObject, baseOptionID: optionIdentifier) {
        switch baseOptionID {
        case .Assignment:
            self.selectedAssignment = baseOption as? Assignment
            self.selectedAssignmentTitle.text = self.selectedAssignment?.title
            self.configureOptions((self.selectedAssignment?.category)!, baseOptionID: .Category)
        case .Category:
            self.selectedCategory = baseOption as? Category
            self.selectedCategoryTitle.text = self.selectedCategory?.title
            self.configureOptions((self.selectedCategory?.course)!, baseOptionID: .Course)
        case .Course:
            self.selectedCourse = baseOption as? Course
            self.selectedCourseTitle.text = self.selectedCourse?.title
            self.configureOptions((self.selectedCourse?.semester)!, baseOptionID: .Semester)
        case .Semester:
            self.selectedSemester = baseOption as! Semester
            self.selectedSemesterTitle.text = self.selectedSemester.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "MMM dd, yyyy \t h:mm a"
        
        // Adding time record from TimeRecordsViewController
        if let selectedAssignment = selectedAssignment {
            self.navigationItem.title = "Add Time Record"
            self.navigationItem.rightBarButtonItem?.title = "Add"
            self.configureOptions(selectedAssignment, baseOptionID: .Assignment)
            
            let currentTimeMinusOneHour = NSDate().dateByAddingTimeInterval(-3600)
            self.startTimePicker.date = roundTimeToNearestIntervalOfMinutes(currentTimeMinusOneHour, intervalInMinutes: 5, roundDown: true)
            self.endTimePicker.date = roundTimeToNearestIntervalOfMinutes(NSDate(), intervalInMinutes: 5, roundDown: true)
        }
            // Editing time record from TimeRecordsViewController
        else if let timeRecordToEdit = timeRecordToEdit {
            self.navigationItem.title = "Edit Time Record"
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.configureOptions(timeRecordToEdit.assignment!, baseOptionID: .Assignment)
            
            self.startTimePicker.date = timeRecordToEdit.startTime!
            self.endTimePicker.date = timeRecordToEdit.endTime!
        }
        
        self.startTimeLabel.text = dateFormatter.stringFromDate(self.startTimePicker.date)
        self.endTimeLabel.text = dateFormatter.stringFromDate(self.endTimePicker.date)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setAddButton()
        self.startTimePickerCell.hidden = true
        self.endTimePickerCell.hidden = true
    }
    
    func setAddButton() {
        self.addButton.enabled = (self.selectedSemester == nil || self.selectedCourse == nil || self.selectedCategory == nil || self.selectedAssignment == nil) ? false : true
    }
    
}

// MARK: Segues

extension TimeRecordDetailViewController {
    
    // Do switches on segue idengitifers rather than using option identifers? But might impact function of next view controller!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowOptions" {
            let selectedIndexPath = sender as! NSIndexPath
            let selectedIdentifier = self.tableView.cellForRowAtIndexPath(selectedIndexPath)?.reuseIdentifier
            
            let destinationController = segue.destinationViewController as! TimeRecordDetailOptionsViewController
            destinationController.delegate = self
            destinationController.optionID = optionIdentifier(rawValue: selectedIdentifier!)
            
            // Determine preselected options (if available) through index path of selected table cell
            switch destinationController.optionID! {
            case .Semester:
                destinationController.selectedOption = selectedSemester
            case .Course:
                destinationController.selectedOption = selectedCourse
                destinationController.selectedParentOption = selectedSemester
            case .Category:
                destinationController.selectedOption = selectedCategory
                destinationController.selectedParentOption = selectedCourse
            case .Assignment:
                destinationController.selectedOption = selectedAssignment
                destinationController.selectedParentOption = selectedCategory
            }
        }
        else if sender === self.addButton {
            timeRecordStartTime = dateFormatter.dateFromString(self.startTimeLabel.text!)
            timeRecordEndTime = dateFormatter.dateFromString(self.endTimeLabel.text!)
        }
    }
    
}


// MARK: UITableViewController Functions

extension TimeRecordDetailViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                return self.startTimePickerCell.hidden ? 0 : 216
            }
            else if indexPath.row == 3 {
                return self.endTimePickerCell.hidden ? 0 : 216
            }
        }
        return self.tableView.rowHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            self.performSegueWithIdentifier("ShowOptions", sender: indexPath)
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                if self.startTimePickerIsHidden {
                    configurePickerCell(startTimePickerCell, hide: false, hiddenStatus: &startTimePickerIsHidden)
                    configurePickerCell(endTimePickerCell, hide: true, hiddenStatus: &endTimePickerIsHidden)
                }
                else {
                    configurePickerCell(startTimePickerCell, hide: true, hiddenStatus: &startTimePickerIsHidden)
                }
            }
            else if indexPath.row == 2 {
                if self.endTimePickerIsHidden {
                    configurePickerCell(endTimePickerCell, hide: false, hiddenStatus: &endTimePickerIsHidden)
                    configurePickerCell(startTimePickerCell, hide: true, hiddenStatus: &startTimePickerIsHidden)
                }
                else {
                    configurePickerCell(endTimePickerCell, hide: true, hiddenStatus: &endTimePickerIsHidden)
                }
            }
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


// MARK: TimePicker Functions

extension TimeRecordDetailViewController {
    
    @IBAction func startTimeHasChanged(sender: UIDatePicker) {
        self.startTimeLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func endTimeHasChanged(sender: UIDatePicker) {
        self.endTimeLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
}


// MARK: TimeRecordDetailOptionsDelegate Functions

extension TimeRecordDetailViewController: TimeRecordDetailOptionsDelegate {
    
    func optionSelected(selectedOption: NSManagedObject, optionID: optionIdentifier) {
        switch optionID {
        case .Semester:
            if selectedOption as! Semester !== self.selectedSemester {
                self.selectedCourse = nil
                self.selectedCategory = nil
                self.selectedAssignment = nil
                resetSelectedOption(self.selectedCourseCell, enabled: true)
                resetSelectedOption(self.selectedCategoryCell, enabled: false)
                resetSelectedOption(self.selectedAssignmentCell, enabled: false)
                setAddButton()
            }
            self.selectedSemester = selectedOption as! Semester
            self.selectedSemesterTitle.text = self.selectedSemester.title
        case .Course:
            if selectedOption as! Course !== self.selectedCourse {
                self.selectedCategory = nil
                self.selectedAssignment = nil
                resetSelectedOption(self.selectedCategoryCell, enabled: true)
                resetSelectedOption(self.selectedAssignmentCell, enabled: false)
                setAddButton()
            }
            self.selectedCourse = selectedOption as? Course
            self.selectedCourseTitle.text = self.selectedCourse!.title
        case .Category:
            if selectedOption as! Category !== self.selectedCategory {
                self.selectedAssignment = nil
                resetSelectedOption(self.selectedAssignmentCell, enabled: true)
                setAddButton()
            }
            self.selectedCategory = selectedOption as? Category
            self.selectedCategoryTitle.text = self.selectedCategory!.title
        case .Assignment:
            self.selectedAssignment = selectedOption as? Assignment
            self.selectedAssignmentTitle.text = self.selectedAssignment!.title
        }
    }
    
    func resetSelectedOption(selectedOptionCell: UITableViewCell, enabled: Bool) {
        // selectedOptionCell.hidden = !enabled
        selectedOptionCell.detailTextLabel?.text = "None"
        selectedOptionCell.userInteractionEnabled = enabled
        selectedOptionCell.textLabel?.enabled = enabled
        selectedOptionCell.detailTextLabel?.enabled = enabled
        selectedOptionCell.accessoryType = enabled ? .DisclosureIndicator : .None
    }
    
}
