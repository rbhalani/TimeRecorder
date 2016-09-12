//
//  CourseGraphContentViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Charts

class CourseGraphContentViewController: BarChartViewController {
    
    @IBOutlet weak var chart: BarChartView!
    
    var dataStack: timeRecordDataStack!
    
    var timeSpentPerWeek = [Double]()
    var weekEnumerations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataStack = (self.parentViewController as! CourseGraphsViewController).dataStack
        
        let selectedSemester = self.dataStack.semester!
        
        let weeks = fetchEntitiesInObject("Week", predicateFormat: "semester = %@", predicateObjects: [selectedSemester], sortKey: "enumeration", sortAscending: true) as! [Week]
        
        for week in weeks {
            self.weekEnumerations.append(String(week.enumeration!))
            self.timeSpentPerWeek.append(0.00)
        }
        
        let timeRecordsInSemester = fetchEntitiesInObject("TimeRecord", predicateFormat: "semester = %@", predicateObjects: [selectedSemester], sortKey: "startTime", sortAscending: true) as! [TimeRecord]
        
        for timeRecord in timeRecordsInSemester {
            self.timeSpentPerWeek[Int(timeRecord.week!.enumeration!) - 1] += timeRecord.timeDurationInHours()
        }
        
        setChart(chart, dataPoints: weekEnumerations, values: timeSpentPerWeek)
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
    
}
