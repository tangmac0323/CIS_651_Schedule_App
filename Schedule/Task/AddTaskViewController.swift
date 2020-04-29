//
//  AddTaskViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddTaskViewController : UIViewController {
    @IBOutlet weak var Save_Button: UIButton!
    
    @IBOutlet weak var TaskTitle_TextField: UITextField!
    @IBOutlet weak var TaskDeadLine_TextField: UITextField!
    @IBOutlet weak var Notification_Switch: UISwitch!
    
    @IBOutlet weak var Note_TextView: UITextView!
    
    var deadLineStr : String?
    
    
    // *********************************************************************************
    // initialize with core data persistence
    // *********************************************************************************
    let coredataRef = PersistenceManager.shared
    
    /*
    init () {
        self.persistenceManager = PersistenceManager.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    // *********************************************************************************
    // override load function
    // *********************************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        initTextField()
        //createDatePickerForTextField()
        //enableDismissDatePickerFromTextField(textField: self.TaskDeadLine_TextField)
    }
    
    // *********************************************************************************
    // init text field
    // *********************************************************************************
    func initTextField() {
        self.TaskDeadLine_TextField.delegate = self
        
        let myFormatter = MyDateManager()
        self.TaskDeadLine_TextField.text = myFormatter.DateToSimplifiedString(date: Date())
        
        self.deadLineStr = myFormatter.DateToFormattedString(date: Date())
    }
    
    // *********************************************************************************
    // add task int core data
    // *********************************************************************************
    
    func createTask() {
        let task = Task(context: coredataRef.context)
        task.content = Note_TextView.text
        
        let myFormatter = MyDateManager()
        task.createTime = myFormatter.DateToFormattedString(date: Date())

        task.endTime = self.deadLineStr
        task.title = TaskTitle_TextField.text
        task.notification = Notification_Switch.isOn
        task.status = false
        task.content = Note_TextView.text
        task.category = EventConstants.EventCategory.Task
        task.selfID = task.objectID.uriRepresentation().absoluteString
        task.notificationAheadTime = NSDecimalNumber(decimal: Decimal(TaskCoredataConstants.NotificationAheadTimeInSec))
        
        coredataRef.saveContext()
        
        
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
        
        self.TaskDeadLine_TextField.text = myFormatter.DateToSimplifiedString(date: sender.date)
        
        self.deadLineStr = myFormatter.DateToFormattedString(date: sender.date)
        
        //print(self.deadLineStr!)
        
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
    
    
    
    @IBAction func SaveButton_Tapped(_ sender: Any) {
        createTask()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AddTaskViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.TaskDeadLine_TextField {
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



