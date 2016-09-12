//
//  TimeRecordsViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TimeRecordsViewController: CoreDataTableViewController {
    
    // MARK: IBOutlets and Properties
    
    var selectedAssignment: Assignment!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        configureView()
    }
    
    func initializeFetchedResultsController() {
        
        let fetchRequest = NSFetchRequest(entityName: "TimeRecord")
        let timeRecordSort = NSSortDescriptor(key: "startTime", ascending: false)
        fetchRequest.sortDescriptors = [timeRecordSort]
        fetchRequest.predicate = NSPredicate(format: "assignment = %@", argumentArray: [selectedAssignment])
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self // self inherits NSFetchedResultsControllerDelegate protocol from CoreDataTableViewController
        
    }
    
    func configureView() {
        self.navigationItem.prompt = "\(selectedAssignment.category!.title!) - \(selectedAssignment.title!)"
        self.navigationItem.title = "Time Records"
        self.graphButton.enabled = false
        self.recordButton.enabled = false
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddTimeRecord" {
            let destinationController = (segue.destinationViewController as! UINavigationController).topViewController as! TimeRecordDetailViewController
            destinationController.selectedAssignment = self.selectedAssignment
        }
        else if segue.identifier == "EditTimeRecord" {
            let destinationController = segue.destinationViewController as! TimeRecordDetailViewController
            destinationController.timeRecordToEdit = sender as? TimeRecord
        }
    }
    
    @IBAction func unwindToTimeRecords(sender: UIStoryboardSegue) {
        guard let sourceController = sender.sourceViewController as? TimeRecordDetailViewController else {
            fatalError("Failed to find source data require to add or edit assignment.")
        }
        
        // Edit an existing time record
        if let timeRecordToEdit = sourceController.timeRecordToEdit {
            // Change creation date?
            timeRecordToEdit.assignment = sourceController.selectedAssignment!
            timeRecordToEdit.course = sourceController.selectedCourse!
            timeRecordToEdit.category = sourceController.selectedCategory!
            timeRecordToEdit.semester = sourceController.selectedSemester
            timeRecordToEdit.startTime = sourceController.timeRecordStartTime
            timeRecordToEdit.endTime = sourceController.timeRecordEndTime
            timeRecordToEdit.setTimeDuration()
            timeRecordToEdit.setWeek()
        }
            // Add a time record
        else {
            let timeRecord = TimeRecord(semester: sourceController.selectedSemester, course: sourceController.selectedCourse!, category: sourceController.selectedCategory!, assignment: sourceController.selectedAssignment!, startTime: sourceController.timeRecordStartTime, endTime: sourceController.timeRecordEndTime, managedObjectContext: fetchedResultsController.managedObjectContext)
        }
        
        print("Saving")
        saveContext()
    }
    
    // MARK: UITableViewController Functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeRecordCell", forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let timeRecord = fetchedResultsController.objectAtIndexPath(indexPath) as! TimeRecord
        cell.textLabel?.text = "\(timeRecord.timeDurationHours!) hours \(timeRecord.timeDurationMinutes!) minutes"
        // cell.detailTextLabel?.text = timeRecord.assignment!.title! // Must change cell format in Storyboard
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") {(editAction, indexPath) in
            let timeRecordToEdit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! TimeRecord
            self.performSegueWithIdentifier("EditTimeRecord", sender: timeRecordToEdit)
        }
        
        return [deleteAction, editAction]
        
    }
    
}
