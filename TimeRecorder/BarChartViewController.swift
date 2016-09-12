//
//  BarChartViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Charts

class BarChartViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).coreDataStack.managedObjectContext
    
    @IBAction func done(sender: UIBarButtonItem) {
        if sender === self.doneButton {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func configureChart(chart: BarChartView) {
        chart.xAxis.labelPosition = .Bottom
        chart.leftAxis.spaceBottom = 0
        chart.leftAxis.axisMinValue = 0
        // chart.autoScaleMinMaxEnabled = true
        chart.xAxis.avoidFirstLastClippingEnabled = true
        chart.xAxis.setLabelsToSkip(0)
        chart.xAxis.drawGridLinesEnabled = true
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        chart.pinchZoomEnabled = true
        chart.descriptionText = ""
        chart.doubleTapToZoomEnabled = false
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
    
}
