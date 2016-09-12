//
//  CourseGraphContentViewController2.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Charts

class CourseGraphContentViewController2: BarChartViewController {
    
    @IBOutlet weak var chart: BarChartView!
    
    var dataStack: timeRecordDataStack!
    
    var timeSpentPerCoursePerWeek = [[Double]]()
    var courseTitles = [String]()
    var weekEnumerations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataStack = (self.parentViewController as! CourseGraphsViewController).dataStack
        
        let selectedSemester = self.dataStack.semester!
        
        let courses = fetchEntitiesInObject("Course", predicateFormat: "semester = %@", predicateObjects: [selectedSemester], sortKey: "title", sortAscending: true) as! [Course]
        
        let weeks = fetchEntitiesInObject("Week", predicateFormat: "semester = %@", predicateObjects: [selectedSemester], sortKey: "enumeration", sortAscending: true) as! [Week]
        
        for week in weeks {
            self.weekEnumerations.append(String(week.enumeration!))
            self.timeSpentPerCoursePerWeek.append([Double]())
            for iteration in 0...courses.count - 1 {
                self.timeSpentPerCoursePerWeek[Int(week.enumeration!) - 1].append(0.00)
            }
        }
        
        var courseIndex = 0
        for course in courses {
            let timeRecordsInCourse = fetchEntitiesInObject("TimeRecord", predicateFormat: "course = %@", predicateObjects: [course], sortKey: "startTime", sortAscending: true) as! [TimeRecord]
            for timeRecord in timeRecordsInCourse {
                self.timeSpentPerCoursePerWeek[Int(timeRecord.week!.enumeration!) - 1][courseIndex] += timeRecord.timeDurationInHours()
            }
            courseIndex += 1
            self.courseTitles.append(course.title!)
        }
        
        setGroupedBarChart(self.chart, dataPoints: weekEnumerations, groupedBarTitles: courseTitles, values: timeSpentPerCoursePerWeek)
    }
    
    func setGroupedBarChart(chart: BarChartView, dataPoints: [String], groupedBarTitles: [String], values: [[Double]]) {
        var chartDataSets = [BarChartDataSet]()
        
        for dataSetIndex in 0...groupedBarTitles.count - 1 {
            var dataEntries = [BarChartDataEntry]()
            
            for index in 0...dataPoints.count - 1 {
                let dataEntry = BarChartDataEntry(value: values[index][dataSetIndex], xIndex: index)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: nil)
            let colorTemplate = ChartColorTemplates.material()
            chartDataSet.colors = [colorTemplate[dataSetIndex % colorTemplate.count]]
            chartDataSets.append(chartDataSet)
            
        }
        
        let chartData = BarChartData(xVals: dataPoints, dataSets: chartDataSets)
        chart.data = chartData
        
        configureChart(chart)
    }
    
    override func configureChart(chart: BarChartView) {
        super.configureChart(chart)
        // chart.leftAxis.addLimitLine(ChartLimitLine(limit: 5))
    }
    
}
