//
//  CategoryDetailViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation

class CategoryDetailViewController: DetailViewController {
    
    // MARK: IBOutlets and Properties
    
    var categoryToEdit: Category?
    
    var categoryTitle: String!
    
    // MARK: Initialization
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    func configureView() {
        // Populate data fields if existing category is to be edited
        if let categoryToEdit = categoryToEdit {
            self.navigationItem.title = "Edit Category"
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.titleTextField.text = categoryToEdit.title
        }
        else {
            self.navigationItem.title = "Add Category"
            self.navigationItem.rightBarButtonItem?.title = "Add"
        }
    }
    
}


// MARK: IBActions and Segues

extension CategoryDetailViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === self.addButton {
            categoryTitle = self.titleTextField.text!
        }
    }
    
}
