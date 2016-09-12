//
//  CoreDataTableViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

struct timeRecordDataStack {
    var semester: Semester?
    var course: Course?
    var category: Category?
    var assignment: Assignment?
    var timeRecord: TimeRecord?
}

class CoreDataTableViewController: UITableViewController {
    
    // MARK: IBOutlets and Properties
    
    @IBOutlet weak var graphButton: UIBarButtonItem!
    @IBOutlet weak var recordButton: UIBarButtonItem!
    
    var dataStack: timeRecordDataStack!
    
    var fetchedResultsController: NSFetchedResultsController! {
        didSet {
            performFetch()
            tableView.reloadData()
        }
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            print("Fetch performed.")
        }
        catch {
            fatalError("Failed to execute NSFetchRequest for FetchedResultsController: \(error)")
        }
    }
    
    func saveContext() {
        if fetchedResultsController.managedObjectContext.hasChanges {
            do {
                try fetchedResultsController.managedObjectContext.save()
            }
            catch {
                fatalError("Error during attempt to save data.")
            }
        }
    }
    
    var deleteAction: UITableViewRowAction!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") {(deleteAction, indexPath) in
            let alertController = UIAlertController(title: "Delete Button Pressed", message: "Confirm to proceed", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {(action) in
                self.setEditing(false, animated: true)
            }
            let proceedAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive) {(action) in
                let managedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
                self.fetchedResultsController.managedObjectContext.deleteObject(managedObject)
                print("Deleting")
                self.saveContext()
            }
            alertController.addAction(cancelAction)
            alertController.addAction(proceedAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.rightBarButtonItem!.enabled = !self.editing
    }
    
}


// MARK: UITableViewController Functions

extension CoreDataTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionsInfo = fetchedResultsController.sections! as [NSFetchedResultsSectionInfo]
        let sectionInfo = sectionsInfo[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}


// MARK: NSFetchedResultsControllerDelegate Functions

extension CoreDataTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
        
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            // configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
}
