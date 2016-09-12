//
//  AssignmentGraphContentViewController2.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Charts

class AssignmentGraphContentViewController2: BarChartViewController {
    
    @IBOutlet weak var chart: BarChartView!
    
    var dataStack: timeRecordDataStack!
    
    var timeSpentPerAssignment = [Double]()
    var assignmentTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataStack = (self.parentViewController as! AssignmentGraphsViewController).dataStack
        
        let assignments = fetchEntitiesInObject("Assignment", predicateFormat: "category = %@", predicateObjects: [self.dataStack.category!], sortKey: "title", sortAscending: true) as! [Assignment]
        
        for assignment in assignments {
            var timeSpent = 0.00
            let timeRecordsInAssignment = fetchEntitiesInObject("TimeRecord", predicateFormat: "assignment = %@", predicateObjects: [assignment], sortKey: "startTime", sortAscending: true) as! [TimeRecord]
            for timeRecord in timeRecordsInAssignment {
                timeSpent += timeRecord.timeDurationInHours()
            }
            self.timeSpentPerAssignment.append(timeSpent)
            self.assignmentTitles.append(assignment.title!)
        }
        
        setChart(self.chart, dataPoints: assignmentTitles, values: timeSpentPerAssignment)
    }
    
    func setChart(chart: BarChartView, dataPoints: [String], values: [Double]) {
        var dataEntries = [BarChartDataEntry]()
        
        for index in 0...dataPoints.count - 1 {
            let dataEntry = BarChartDataEntry(value: values[index], xIndex: index)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Time Spent")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        chart.data = chartData
        
        configureChart(chart)
    }
    
    override func configureChart(chart: BarChartView) {
        super.configureChart(chart)
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.addLimitLine(ChartLimitLine(limit: 5))
    }
    
}
