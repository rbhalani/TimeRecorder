//
//  SemestersViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

// Can DataStack struct further streamline code?

class SemestersViewController: CoreDataTableViewController {
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataStack = timeRecordDataStack()
        initializeFetchedResultsController()
        configureView()
    }
    
    func initializeFetchedResultsController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Semester")
        let semesterSort = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [semesterSort]
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self // self inherits NSFetchedResultsControllerDelegate protocol from CoreDataTableViewController
        
    }
    
    func configureView() {
        self.navigationItem.title = "Semesters"
        self.navigationItem.prompt = "TimeRecorder"
        self.graphButton.enabled = false
        self.recordButton.enabled = false
    }
    
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddSemester" {
            // No code to execute
        }
        else if segue.identifier == "EditSemester" {
            let destinationController = segue.destinationViewController as! SemesterDetailViewController
            destinationController.semesterToEdit = sender as? Semester
        }
        else if segue.identifier == "ShowCourses" {
            let destinationController = segue.destinationViewController as! CoursesViewController
            destinationController.dataStack = self.dataStack
            destinationController.dataStack.semester = sender as? Semester
            destinationController.selectedSemester = sender as! Semester
        }
    }
    
    @IBAction func unwindToSemesters(sender: UIStoryboardSegue) {
        guard let sourceController = sender.sourceViewController as? SemesterDetailViewController else {
            fatalError("Failed to find source data require to add or edit semester.")
        }
        
        // Edit an existing semester
        if let semesterToEdit = sourceController.semesterToEdit {
            semesterToEdit.title = sourceController.semesterTitle
            semesterToEdit.startDate = sourceController.semesterStartDate
            semesterToEdit.endDate = sourceController.semesterEndDate
            semesterToEdit.initializeWeeksOfSemester(fetchedResultsController.managedObjectContext)
        }
        // Add a semester
        else {
            let semester = Semester(title: sourceController.semesterTitle, startDate: sourceController.semesterStartDate, endDate: sourceController.semesterEndDate, managedObjectContext: fetchedResultsController.managedObjectContext)
            semester.testInitializeWeeksOfSemester()
        }
        
        print("Saving")
        saveContext()
    }
    
    
    // MARK: UITableViewController Functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SemesterCell", forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let semester = fetchedResultsController.objectAtIndexPath(indexPath) as! Semester
        cell.textLabel?.text = semester.title
        cell.detailTextLabel?.text = "\(dateFormatter.stringFromDate(semester.startDate!)) - \(dateFormatter.stringFromDate(semester.endDate!))"
        cell.accessoryType = .DisclosureIndicator
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedSemester = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Semester
        self.performSegueWithIdentifier("ShowCourses", sender: selectedSemester)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") {(editAction, indexPath) in
            let semesterToEdit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Semester
            self.performSegueWithIdentifier("EditSemester", sender: semesterToEdit)
        }
        
        return [deleteAction, editAction]
        
    }
    
}
