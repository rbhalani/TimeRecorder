//
//  CourseDetailViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation

class CourseDetailViewController: DetailViewController {
    
    // MARK: IBOutlets and Properties
    
    var courseToEdit: Course?
    
    var courseTitle: String!
    
    // MARK: Initialization
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        // Populate data fields if existing course is to be edited
        if let courseToEdit = courseToEdit {
            self.navigationItem.title = "Edit Course"
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.titleTextField.text = courseToEdit.title
        }
        else {
            self.navigationItem.title = "Add Course"
            self.navigationItem.rightBarButtonItem?.title = "Add"
        }
    }
    
}


// MARK: IBActions and Segues

extension CourseDetailViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === self.addButton {
            courseTitle = self.titleTextField.text!
        }
    }
    
}
