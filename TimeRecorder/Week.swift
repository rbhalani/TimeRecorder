//
//  Week.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import Foundation
import CoreData


class Week: NSManagedObject {

    convenience init(semester: Semester, startDate: NSDate, endDate: NSDate, managedObjectContext: NSManagedObjectContext) {
        
        if let entityDescription = NSEntityDescription.entityForName("Week", inManagedObjectContext: managedObjectContext) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            self.semester = semester
            self.startDate = startDate
            self.endDate = endDate
            self.title = String(self.enumeration)
            self.timeRecords = NSSet()
        } else {
            fatalError("Error: Could not find entity.")
        }
        
    }

}
