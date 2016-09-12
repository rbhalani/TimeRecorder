//
//  CourseGraphsViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Charts

class CourseGraphsViewController: UIPageViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var optionID: optionIdentifier!
    var dataStack: timeRecordDataStack!
    
    private(set) lazy var orderedGraphs: [UIViewController] = {
        return [self.newGraph("CourseGraphContentViewController"), self.newGraph("CourseGraphContentViewController2")]
    }()
    
    private func newGraph(identifier: String) -> UIViewController {
        return (self.storyboard?.instantiateViewControllerWithIdentifier(identifier))!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstGraph = orderedGraphs.first {
            setViewControllers([firstGraph], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if sender === self.doneButton {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}


extension CourseGraphsViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedGraphs.indexOf(viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return orderedGraphs[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedGraphs.indexOf(viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedGraphs.count > nextIndex else {
            return nil
        }
        
        return orderedGraphs[nextIndex]
    }
    
}
