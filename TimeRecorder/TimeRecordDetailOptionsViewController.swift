//
//  TimeRecordDetailOptionsViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData

protocol TimeRecordDetailOptionsDelegate {
    func optionSelected(selectedOption: NSManagedObject, optionID: optionIdentifier)
}

class TimeRecordDetailOptionsViewController: UITableViewController {
    
    var optionID: optionIdentifier!
    var options: [NSManagedObject]!
    var selectedOption: NSManagedObject?
    var selectedParentOption: NSManagedObject?
    var hasCustomCell = false
    
    var delegate: TimeRecordDetailOptionsDelegate!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureOptions()
    }
    
    func fetchEntitiesInObject(entityName: String, predicateFormat: String?, predicateObjects: [NSManagedObject]?, sortKey: String, sortAscending: Bool) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        let fetchSort = NSSortDescriptor(key: sortKey, ascending: sortAscending)
        fetchRequest.sortDescriptors = [fetchSort]
        
        if let predicateFormat = predicateFormat, predicateObjects = predicateObjects {
            fetchRequest.predicate = NSPredicate(format: predicateFormat, argumentArray: predicateObjects)
        }
        
        do {
            let fetchedEntities = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            return fetchedEntities
        }
        catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
    }
    
    func configureOptions() {
        switch self.optionID! {
        case .Semester:
            self.options = fetchEntitiesInObject("Semester", predicateFormat: nil, predicateObjects: nil, sortKey: "startDate", sortAscending: false) as! [Semester]
        case .Course:
            if let selectedParentOption = selectedParentOption as? Semester {
                self.options = fetchEntitiesInObject("Course", predicateFormat: "semester = %@", predicateObjects: [selectedParentOption], sortKey: "title", sortAscending: true) as! [Course]
            }
        case .Category:
            if let selectedParentOption = selectedParentOption as? Course {
                self.options = fetchEntitiesInObject("Category", predicateFormat: "course = %@", predicateObjects: [selectedParentOption], sortKey: "title", sortAscending: true) as! [Category]
            }
        case .Assignment:
            if let selectedParentOption = selectedParentOption as? Category {
                self.options = fetchEntitiesInObject("Assignment", predicateFormat: "category = %@", predicateObjects: [selectedParentOption], sortKey: "title", sortAscending: true) as! [Assignment]
            }
        }
    }
    
}


// MARK: UITableViewController Functions

extension TimeRecordDetailOptionsViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath)
        let option = self.options![indexPath.row]
        
        cell.accessoryType = (option === selectedOption) ? .Checkmark : .None
        
        switch self.optionID! {
        case .Semester:
            cell.textLabel?.text = (option as! Semester).title
        case .Course:
            cell.textLabel?.text = (option as! Course).title
        case .Category:
            cell.textLabel?.text = (option as! Category).title
        case .Assignment:
            cell.textLabel?.text = (option as! Assignment).title
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedOption = self.options![indexPath.row]
        self.delegate.optionSelected(selectedOption!, optionID: self.optionID!)
        
        self.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}


extension TimeRecordDetailOptionsViewController {
    
    // public vs. internal
    internal func determinePreselectedSemester() -> Semester? {
        let fetchedSemesters = fetchEntitiesInObject("Semester", predicateFormat: nil, predicateObjects: nil, sortKey: "startDate", sortAscending: false) as! [Semester]
        return fetchedSemesters.first
    }
    
}
