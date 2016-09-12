//
//  CategoriesViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CategoriesViewController: CoreDataTableViewController {
    
    // MARK: IBOutlets and Properties
    
    var selectedCourse: Course!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFetchedResultsController()
        configureView()
    }
    
    func initializeFetchedResultsController() {
        
        let fetchRequest = NSFetchRequest(entityName: "Category")
        let categorySort = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [categorySort]
        fetchRequest.predicate = NSPredicate(format: "course = %@", argumentArray: [selectedCourse])
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self // self inherits NSFetchedResultsControllerDelegate protocol from CoreDataTableViewController
        
    }
    
    func configureView() {
        self.navigationItem.prompt = "\(selectedCourse.semester!.title!) - \(selectedCourse.title!)"
        self.navigationItem.title = "Categories"
        self.recordButton.enabled = false
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCategory" {
            // No code to execute
        }
        else if segue.identifier == "EditCategory" {
            let destinationController = segue.destinationViewController as! CategoryDetailViewController
            destinationController.categoryToEdit = sender as? Category
        }
        else if segue.identifier == "ShowAssignments" {
            let destinationController = segue.destinationViewController as! AssignmentsViewController
            destinationController.dataStack = self.dataStack
            destinationController.dataStack.category = sender as? Category
            destinationController.selectedCategory = sender as! Category
        }
        else if sender === self.graphButton {
            let destinationController = (segue.destinationViewController as! UINavigationController).topViewController as! CategoryGraphsViewController
            destinationController.dataStack = self.dataStack
        }
    }
    
    @IBAction func unwindToCategories(sender: UIStoryboardSegue) {
        guard let sourceController = sender.sourceViewController as? CategoryDetailViewController else {
            fatalError("Failed to find source data require to add or edit category.")
        }
        
        // Edit an existing category
        if let categoryToEdit = sourceController.categoryToEdit {
            categoryToEdit.title = sourceController.categoryTitle
        }
            // Add a category
        else {
            let category = Category(title: sourceController.categoryTitle, managedObjectContext: fetchedResultsController.managedObjectContext)
            category.course = selectedCourse
        }
        
        print("Saving")
        saveContext()
    }
    
    // MARK: UITableViewController Functions
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let category = fetchedResultsController.objectAtIndexPath(indexPath) as! Category
        cell.textLabel?.text = category.title
        cell.accessoryType = .DisclosureIndicator
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCategory = fetchedResultsController.objectAtIndexPath(indexPath) as! Category
        self.performSegueWithIdentifier("ShowAssignments", sender: selectedCategory)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") {(editAction, indexPath) in
            let categoryToEdit = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Category
            self.performSegueWithIdentifier("EditCategory", sender: categoryToEdit)
        }
        
        return [deleteAction, editAction]
        
    }
    
}
