//
//  DetailViewController.swift
//  TimeRecorder
//
//  Created by Rushi Bhalani on 8/5/16.
//  Copyright © 2016 Rushi Bhalani. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UITableViewController {
    
    // MARK: IBOutlets and Properties
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    let dateFormatter = NSDateFormatter()
    
    // MARK: Initialization
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.titleTextField != nil {
            self.titleTextField.delegate = self
            self.titleTextField.placeholder = "Title"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.titleTextField != nil {
            self.titleTextField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: IBActions and Segues
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        if sender === self.cancelButton {
            if self.presentingViewController is UINavigationController {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
}


// MARK: Picker Functions

extension DetailViewController {
    
    func configurePickerCell(pickerCell: UITableViewCell, hide: Bool, inout hiddenStatus pickerCellIsHidden: Bool) {
        pickerCell.hidden = hide
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        pickerCellIsHidden = hide
    }
    
    func roundTimeToNearestIntervalOfMinutes(time: NSDate, intervalInMinutes: Int, roundDown: Bool) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let minuteComponent = calendar.component(.Minute, fromDate: time)
        let minutesToAdd = roundDown ? (0 - (minuteComponent % intervalInMinutes)) : (intervalInMinutes - (minuteComponent % intervalInMinutes))
        
        return calendar.dateByAddingUnit(.Minute, value: minutesToAdd, toDate: time, options: [])!
    }
    
    // 2 parameters not permitted?
    @IBAction func pickerHasChanged(sender: UIDatePicker, senderLabel: UILabel) {
        senderLabel.text = dateFormatter.stringFromDate(sender.date)
    }
    
}


// MARK: UITextFieldDelegate Functions

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.addButton.enabled = (textField.text == "") ? false : true
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.addButton.enabled = ("\(textField.text)\(string)") == "" ? false : true
        if textField.text?.characters.count == 1 && string.characters.count == 0 {
            self.addButton.enabled = false
        }
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        self.addButton.enabled = false
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.addButton.enabled = (textField.text == "") ? false : true
        return true
    }
    
    // Collapse pickerCells upon editing text field
    
}
