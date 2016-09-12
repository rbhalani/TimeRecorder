//
//  SemesterDetailViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation

class SemesterDetailViewController: DetailViewController {
    
    // MARK: IBOutlets and Properties
    
    @IBOutlet weak var startDatePickerCell: UITableViewCell!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var startDateLabel: UILabel!
    var startDatePickerIsHidden = true
    
    @IBOutlet weak var endDatePickerCell: UITableViewCell!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    var endDatePickerIsHidden = true
    
    var semesterToEdit: Semester?
    
    var semesterTitle: String!
    var semesterStartDate: NSDate!
    var semesterEndDate: NSDate!
    
    // MARK: Initialization
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        self.dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        // Populate data fields if existing Semester is to be edited
        if let semesterToEdit = semesterToEdit {
            self.navigationItem.title = "Edit Semester"
            self.navigationItem.rightBarButtonItem?.title = "Done"
            
            self.titleTextField.text = semesterToEdit.title
            self.startDatePicker.date = semesterToEdit.startDate!
            self.endDatePicker.date = semesterToEdit.endDate!
        }
        else {
            self.navigationItem.title = "Add Semester"
            self.navigationItem.rightBarButtonItem?.title = "Add"
        }
        
        self.startDateLabel.text = dateFormatter.stringFromDate(self.startDatePicker.date)
        self.endDateLabel.text = dateFormatter.stringFromDate(self.endDatePicker.date)
        
        self.startDatePickerCell.hidden = true
        self.endDatePickerCell.hidden = true
    }
    
}


// MARK: UITableViewController Functions

extension SemesterDetailViewController {
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                return self.startDatePickerCell.hidden ? 0 : 216
            }
            else if indexPath.row == 3 {
                return self.endDatePickerCell.hidden ? 0 : 216
            }
        }
        return self.tableView.rowHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            self.textFieldShouldReturn(self.titleTextField)
            if indexPath.row == 0 {
                if self.startDatePickerIsHidden {
                    configurePickerCell(startDatePickerCell, hide: false, hiddenStatus: &startDatePickerIsHidden)
                    configurePickerCell(endDatePickerCell, hide: true, hiddenStatus: &endDatePickerIsHidden)
                }
                else {
                    configurePickerCell(startDatePickerCell, hide: true, hiddenStatus: &startDatePickerIsHidden)
                }
            }
            else if indexPath.row == 2 {
                if self.endDatePickerIsHidden {
                    configurePickerCell(endDatePickerCell, hide: false, hiddenStatus: &endDatePickerIsHidden)
                    configurePickerCell(startDatePickerCell, hide: true, hiddenStatus: &startDatePickerIsHidden)
                }
                else {
                    configurePickerCell(endDatePickerCell, hide: true, hiddenStatus: &endDatePickerIsHidden)
                }
            }
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


// MARK: DatePicker Functions

extension SemesterDetailViewController {
    
    @IBAction func startDateHasChanged(sender: UIDatePicker) {
        self.startDateLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
    @IBAction func endDateHasChanged(sender: UIDatePicker) {
        self.endDateLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
}


// MARK: IBActions and Segues

extension SemesterDetailViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === self.addButton {
            semesterTitle = self.titleTextField.text!
            semesterStartDate = dateFormatter.dateFromString(self.startDateLabel.text!)!
            semesterEndDate = dateFormatter.dateFromString(self.endDateLabel.text!)!
        }
    }
    
}


// Check data
// Ensure End Date >= Start Date
