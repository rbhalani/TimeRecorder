//
//  Category+CoreDataProperties.swift
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

extension Category {

    @NSManaged var title: String?
    @NSManaged var assignments: NSSet?
    @NSManaged var course: Course?
    @NSManaged var timeRecords: NSSet?

}
