//
//  AssignmentsViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class AssignmentsViewController: CoreDataTableViewController {
    
    // MARK: IBOutlets and Properties
    
    var selectedCategory: Category!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        configureView()
    }
    
    func initializeFetchedResultsController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Assignment")
        let assignmentSort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [assignmentSort]
        fetchRequest.predicate = NSPredicate(format: "category = %@", argumentArray: [selectedCategory])
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self // self inherits NSFetchedResultsControllerDelegate protocol from CoreDataTableViewController
        
    }
    
    func configureView() {
        self.navigationItem.prompt = "\(selectedCategory.course!.title!) - \(selectedCategory.title!)"
        self.navigationItem.title = "Assignments"
        self.recordButton.enabled = false
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddAssignment" {
            // No code to execute
        }
        else if segue.identifier == "EditAssignment" {
            let destinationController = segue.destinationViewController as! AssignmentDetailViewController
            destinationController.assignmentToEdit = sender as? Assignment
        }
        else if segue.identifier == "ShowTimeRecords" {
            let destinationController = segue.destinationViewController as! TimeRecordsViewController
            destinationController.dataStack = self.dataStack
            destinationController.dataStack.assignment = sender as? Assignment
            destinationController.selectedAssignment = sender as! Assignment
        }
        else if sender === self.graphButton {
            let destinationController = (segue.destinationViewController as! UINavigationController).topViewController as! AssignmentGraphsViewController
            destinationController.dataStack = self.dataStack
        }
    }
    
    @IBAction func unwindToAssignments(sender: UIStoryboardSegue) {
        guard let sourceController = sender.sourceViewController as? AssignmentDetailViewController else {
            fatalError("Failed to find source data require to add or edit assignment.")
        }
        
        // Edit an existing assignment
        if let assignmentToEdit = sourceController.assignmentToEdit {
            assignmentToEdit.title = sourceController.assignmentTitle
        }
            // Add an assignment
        else {
            let assignment = Assignment(title: sourceController.assignmentTitle, managedObjectContext: fetchedResultsController.managedObjectContext)
            assignment.category = selectedCategory
        }
        
        print("Saving")
        saveContext()
    }
    
    // MARK: UITableViewController Functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AssignmentCell", forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let assignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        cell.textLabel?.text = assignment.title
        cell.accessoryType = .DisclosureIndicator
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedAssignment = fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
        self.performSegueWithIdentifier("ShowTimeRecords", sender: selectedAssignment)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") {(editAction, indexPath) in
            let assignmentToEdit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Assignment
            self.performSegueWithIdentifier("EditAssignment", sender: assignmentToEdit)
        }
        
        return [deleteAction, editAction]
        
    }
    
}
