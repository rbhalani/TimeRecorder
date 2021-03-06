//
//  Course.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import Foundation
import CoreData


class Course: NSManagedObject {

    convenience init(title: String, managedObjectContext: NSManagedObjectContext) {
        
        if let entityDescription = NSEntityDescription.entityForName("Course", inManagedObjectContext: managedObjectContext) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            self.title = title
            self.categories = NSSet()
            self.timeRecords = NSSet()
        } else {
            fatalError("Error: Could not find entity.")
        }
        
    }

}
