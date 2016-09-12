//
//  TimeRecord+CoreDataProperties.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimeRecord {

    @NSManaged var endTime: NSDate?
    @NSManaged var startTime: NSDate?
    @NSManaged var timeDurationHours: NSNumber?
    @NSManaged var timeDurationMinutes: NSNumber?
    @NSManaged var assignment: Assignment?
    @NSManaged var category: Category?
    @NSManaged var course: Course?
    @NSManaged var notes: NSSet?
    @NSManaged var semester: Semester?
    @NSManaged var week: Week?

}
