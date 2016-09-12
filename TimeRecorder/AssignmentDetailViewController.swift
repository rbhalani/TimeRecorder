//
//  AssignmentDetailViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation

class AssignmentDetailViewController: DetailViewController {
    
    // MARK: IBOutlets and Properties
    
    var assignmentToEdit: Assignment?
    
    var assignmentTitle: String!
    
    // MARK: Initialization
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        // Populate data fields if existing assignment is to be edited
        if let assignmentToEdit = assignmentToEdit {
            self.navigationItem.title = "Edit Assignment"
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.titleTextField.text = assignmentToEdit.title
        }
        else {
            self.navigationItem.title = "Add Assignment"
            self.navigationItem.rightBarButtonItem?.title = "Add"
        }
    }
    
}

// MARK: IBActions and Segues

extension AssignmentDetailViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === self.addButton {
            assignmentTitle = self.titleTextField.text!
        }
    }
    
}
