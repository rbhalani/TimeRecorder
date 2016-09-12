//
//  CategoryGraphContentViewController2.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Charts

class CategoryGraphContentViewController2: BarChartViewController {
    
    @IBOutlet weak var chart: BarChartView!
    
    var dataStack: timeRecordDataStack!
    
    var timeSpentPerCategoryPerWeek = [[Double]]()
    var categoryTitles = [String]()
    var weekEnumerations = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataStack = (self.parentViewController as! CategoryGraphsViewController).dataStack
        
        let selectedCourse = self.dataStack.course!
        let selectedSemester = self.dataStack.semester!
        
        let categories = fetchEntitiesInObject("Category", predicateFormat: "course = %@", predicateObjects: [selectedCourse], sortKey: "title", sortAscending: true) as! [Category]
        
        let weeks = fetchEntitiesInObject("Week", predicateFormat: "semester = %@", predicateObjects: [selectedSemester], sortKey: "enumeration", sortAscending: true) as! [Week]
        
        for week in weeks {
            self.weekEnumerations.append(String(week.enumeration!))
            self.timeSpentPerCategoryPerWeek.append([Double]())
            for iteration in 0...categories.count - 1 {
                self.timeSpentPerCategoryPerWeek[Int(week.enumeration!) - 1].append(0.00)
            }
        }
        
        var categoryIndex = 0
        for category in categories {
            let timeRecordsInCategory = fetchEntitiesInObject("TimeRecord", predicateFormat: "category = %@", predicateObjects: [category], sortKey: "startTime", sortAscending: true) as! [TimeRecord]
            for timeRecord in timeRecordsInCategory {
                self.timeSpentPerCategoryPerWeek[Int(timeRecord.week!.enumeration!) - 1][categoryIndex] += timeRecord.timeDurationInHours()
            }
            categoryIndex += 1
            self.categoryTitles.append(category.title!)
        }
        
        setGroupedBarChart(self.chart, dataPoints: weekEnumerations, groupedBarTitles: categoryTitles, values: timeSpentPerCategoryPerWeek)
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
