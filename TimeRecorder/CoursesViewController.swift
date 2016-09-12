//
//  CoursesViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CoursesViewController: CoreDataTableViewController {
    
    // MARK: IBOutlets and Properties
    
    var selectedSemester: Semester!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        configureView()
    }
    
    func initializeFetchedResultsController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Course")
        let courseSort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [courseSort]
        fetchRequest.predicate = NSPredicate(format: "semester = %@", argumentArray: [selectedSemester])
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self // self inherits NSFetchedResultsControllerDelegate protocol from CoreDataTableViewController
        
    }
    
    func configureView() {
        self.navigationItem.prompt = selectedSemester.title!
        self.navigationItem.title = "Courses"
        self.recordButton.enabled = false
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCourse" {
            // No code to execute
        }
        else if segue.identifier == "EditCourse" {
            let destinationController = segue.destinationViewController as! CourseDetailViewController
            destinationController.courseToEdit = sender as? Course
        }
        else if segue.identifier == "ShowCategories" {
            let destinationController = segue.destinationViewController as! CategoriesViewController
            destinationController.dataStack = self.dataStack
            destinationController.dataStack.course = sender as? Course
            destinationController.selectedCourse = sender as! Course
        }
        else if sender === self.graphButton {
            let destinationController = (segue.destinationViewController as! UINavigationController).topViewController as! CourseGraphsViewController
            destinationController.dataStack = self.dataStack
        }
    }
    
    @IBAction func unwindToCourses(sender: UIStoryboardSegue) {
        guard let sourceController = sender.sourceViewController as? CourseDetailViewController else {
            fatalError("Failed to find source data require to add or edit course.")
        }
        
        // Edit an existing course
        if let courseToEdit = sourceController.courseToEdit {
            courseToEdit.title = sourceController.courseTitle
        }
            // Add a course
        else {
            let course = Course(title: sourceController.courseTitle, managedObjectContext: fetchedResultsController.managedObjectContext)
            course.semester = selectedSemester
        }
        
        print("Saving")
        saveContext()
    }
    
    // MARK: UITableViewController Functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let course = fetchedResultsController.objectAtIndexPath(indexPath) as! Course
        cell.textLabel?.text = course.title
        cell.accessoryType = .DisclosureIndicator
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCourse = fetchedResultsController.objectAtIndexPath(indexPath) as! Course
        self.performSegueWithIdentifier("ShowCategories", sender: selectedCourse)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") {(editAction, indexPath) in
            let courseToEdit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Course
            self.performSegueWithIdentifier("EditCourse", sender: courseToEdit)
        }
        
        return [deleteAction, editAction]
        
    }
    
}
