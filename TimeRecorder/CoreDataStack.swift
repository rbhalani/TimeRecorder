//
//  CoreDataStack.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    var managedObjectContext : NSManagedObjectContext
    
    override init() {
        
        guard let modelURL = NSBundle.mainBundle().URLForResource("RecordModel", withExtension: "momd") else {
            fatalError("Error: Could not load model from bundle.")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error: Could not initialize managedObjectModel from: \(modelURL).")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex - 1]
            let storeURL = docURL.URLByAppendingPathComponent("RecordModel.sqlite")
            
            do {
                try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            }
            catch {
                fatalError("Could not migrate store: \(error)")
            }
            
        }
        
        super.init() // Need this initalization?
        
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }
            catch {
                fatalError("Error during attempt to save data.")
            }
        }
    }
    
}
