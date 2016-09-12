//
//  Semester.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import Foundation
import CoreData


class Semester: NSManagedObject {

    convenience init(title: String, startDate: NSDate, endDate: NSDate, managedObjectContext: NSManagedObjectContext) {
        
        if let entityDescription = NSEntityDescription.entityForName("Semester", inManagedObjectContext: managedObjectContext) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            self.title = title
            self.startDate = startDate
            self.endDate = endDate
            self.courses = NSSet()
            self.timeRecords = NSSet()
            self.weeks = NSSet()
            
            self.initializeWeeksOfSemester(managedObjectContext)
        } else {
            fatalError("Error: Could not find entity.")
        }
        
    }
    
    
    func initializeWeeksOfSemester(managedObjectContext: NSManagedObjectContext) {
        
        if self.weeks!.count != 0 {
            self.deleteWeeksOfSemester(managedObjectContext)
        }
        
        let calendar = NSCalendar.currentCalendar()
        
        var currentStartDate = self.startDate!
        var enumeration = 1
        
        enumerationLoop: while(true) {
            
            // Find succeeding Sundays (Inclusive vs. Exclusive?)(Or end on Saturdays?)
            let currentEndDate = calendar.nextDateAfterDate(currentStartDate, matchingUnit: NSCalendarUnit.Weekday, value: 1, options: NSCalendarOptions.MatchNextTime)!
            
            switch currentEndDate.compare(self.endDate!) {
            // Check if reached endDate
            case NSComparisonResult.OrderedDescending, NSComparisonResult.OrderedSame:
                let week = Week(semester: self, startDate: currentStartDate, endDate: self.endDate!, managedObjectContext: managedObjectContext)
                week.enumeration = enumeration
                break enumerationLoop
            // Prepare for next iteration
            default:
                let week = Week(semester: self, startDate: currentStartDate, endDate: currentEndDate, managedObjectContext: managedObjectContext)
                week.enumeration = enumeration
                currentStartDate = currentEndDate
                enumeration += 1
            }
            
        }
        
        print("Weeks Initialized")
        
    }
    
    
    func deleteWeeksOfSemester(managedObjectContext: NSManagedObjectContext) {
        
        for week in self.weeks! {
            managedObjectContext.deleteObject(week as! NSManagedObject)
        }
        print("Weeks Deleted")
        
    }
    
    
    func testInitializeWeeksOfSemester() {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        for week in self.weeks! {
            let week = week as! Week
            let stringStartDate = dateFormatter.stringFromDate(week.startDate!)
            let stringEndDate = dateFormatter.stringFromDate(week.endDate!)
            print("\(week.enumeration!) : \(stringStartDate) | \(stringEndDate)")
        }
        
    }

}
