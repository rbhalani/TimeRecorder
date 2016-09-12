//
//  TimeRecord.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import Foundation
import CoreData


class TimeRecord: NSManagedObject {

    convenience init(semester: Semester, course: Course, category: Category, assignment: Assignment, startTime: NSDate, endTime: NSDate, managedObjectContext: NSManagedObjectContext) {
        
        if let entityDescription = NSEntityDescription.entityForName("TimeRecord", inManagedObjectContext: managedObjectContext) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            self.semester = semester
            self.course = course
            self.category = category
            self.assignment = assignment
            self.startTime = startTime
            self.endTime = endTime
            
            setTimeDuration()
            setWeek()
            
            self.notes = NSSet()
        } else {
            fatalError("Error: Could not find entity.")
        }
        
    }
    
    func setTimeDuration() {
        let timeDuration = calculateTimeDuration(self.startTime!, endTime: self.endTime!)
        self.timeDurationHours = timeDuration.hour
        self.timeDurationMinutes = timeDuration.minute
    }
    
    func calculateTimeDuration(startTime: NSDate, endTime: NSDate) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        
        let calendarUnits: NSCalendarUnit = [.Hour, .Minute]
        let timeDuration = calendar.components(calendarUnits, fromDate: startTime, toDate: endTime, options: [])
        
        return timeDuration
    }
    
    func setWeek() {
        for week in self.semester!.weeks! {
            let week = week as! Week
            if isBetweenDates(self.startTime!, startDate: week.startDate!, endDate: week.endDate!) {
                self.week = week
                print(self.week!.enumeration!)
                return
            }
        }
    }
    
    // OrderedSame for endDate?
    func isBetweenDates(date: NSDate, startDate: NSDate, endDate: NSDate) -> Bool {
        if date.compare(startDate) == NSComparisonResult.OrderedAscending {
            return false
        }
        if date.compare(endDate) == NSComparisonResult.OrderedDescending || date.compare(endDate) == NSComparisonResult.OrderedSame {
            return false
        }
        return true
    }
    
    func timeDurationInHours() -> Double {
        return (Double(self.timeDurationHours!) + (Double(self.timeDurationMinutes!) / 60))
    }

}
