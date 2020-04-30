//
//  EditTaskViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/29/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class EditTaskViewController : UIViewController {
    
    @IBOutlet weak var TaskTitle_TextField: UITextField!
    @IBOutlet weak var TaskDDL_TextField: UITextField!
    
    @IBOutlet weak var Note_TextView: UITextView!
    
    @IBOutlet weak var Save_Button: UIButton!
    
    var deadLineStr : String?
    var selectedObject : Task?  // pass in task object reference
    
    // *********************************************************************************
    // initialize with core data persistence
    // *********************************************************************************
    let coredataRef = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initTextField()
        loadDataFromObject(task: self.selectedObject!)
    }
    
    // *********************************************************************************
    // init text field
    // *********************************************************************************
    func initTextField() {
        self.TaskDDL_TextField.delegate = self
        
        //let myFormatter = MyDateManager()
        //self.TaskDDL_TextField.text = myFormatter.DateToSimplifiedString(date: Date())
        
        //self.deadLineStr = myFormatter.DateToFormattedString(date: Date())
    }
    
    // *********************************************************************************
    // load data
    // *********************************************************************************
    func loadDataFromObject(task : Task) {
        let myFormatter = MyDateManager()
        self.TaskDDL_TextField.text = myFormatter.FormattedToSimplified(datestr: task.endTime!)
        self.TaskTitle_TextField.text = task.title
        //self.Notification_Switch.isOn = task.notification
        self.Note_TextView.text = task.content
        self.deadLineStr = self.TaskDDL_TextField.text
    }
    
    // *********************************************************************************
    // update data
    // *********************************************************************************
    func updateDataToObject(task : Task) {
        task.setValue(self.deadLineStr, forKey: TaskCoredataConstants.EndTime)
        task.setValue(self.TaskTitle_TextField.text, forKey: TaskCoredataConstants.Title)
        //task.setValue(self.Notification_Switch.isOn, forKey: TaskCoredataConstants.Notification)
        task.setValue(self.Note_TextView.text, forKey: TaskCoredataConstants.Content)
        task.setValue(NSDecimalNumber(decimal: Decimal(TaskCoredataConstants.NotificationAheadTimeInSec)), forKey: TaskCoredataConstants.NotificationAheadTime)
    }
    // *********************************************************************************
    // set the input view of college textfied into date picker
    // *********************************************************************************
    
    func createDatePickerForTextField(textField : UITextField) {
        let datePicker = UIDatePicker()
        
        //pickerviEW
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged(sender:)), for: .valueChanged)
        //datePicker.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged(sender:)), for: .allEvents)
        
        textField.inputView = datePicker
    }
    
    
    @objc func datePickerValueChanged(sender : UIDatePicker) {
        
        let myFormatter = MyDateManager()
        /*
         let formatter = DateFormatter()
         
         formatter.dateStyle = DateFormatter.Style.medium
         formatter.timeStyle = DateFormatter.Style.medium
         */
        
        self.TaskDDL_TextField.text = myFormatter.DateToSimplifiedString(date: sender.date)
        
        self.deadLineStr = myFormatter.DateToFormattedString(date: sender.date)
        
        //let formatter = TimeFormatterManager()
        //let dateStr = formatter.timeFormatter(date: sender.date)
        //self.TaskDeadLine_TextField.text = dateStr
    }
    
    func enableDismissDatePickerFromTextField( textField : UITextField ) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.endDatePicker))
        
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func endDatePicker() {
        view.endEditing(true)
    }
    
    
    // *********************************************************************************
    // save the update on click and go back to previous page
    // *********************************************************************************
    @IBAction func SaveButton_Tapped(_ sender: Any) {
        updateDataToObject(task: self.selectedObject!)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditTaskViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.TaskDDL_TextField {
            createDatePickerForTextField(textField: textField)
            enableDismissDatePickerFromTextField(textField: textField)
            
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
