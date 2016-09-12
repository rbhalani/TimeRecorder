//
//  Course+CoreDataProperties.swift
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

extension Course {

    @NSManaged var title: String?
    @NSManaged var categories: NSSet?
    @NSManaged var semester: Semester?
    @NSManaged var timeRecords: NSSet?

}
