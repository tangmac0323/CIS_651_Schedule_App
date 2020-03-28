//
//  addAssignmentViewController.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/17.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class addAssignmentViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var timeTextField: UITextField!
    
    
    private var datePicker: UIDatePicker?
    private var timePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AssignmentManager.shared.setAssignment(assign: "assignment is 2")
        self.initDatePicker()
        self.initTimePicker()
    }
    
    /*
     *  Fuction to initialize date picker property for dateTextField
     */
    func initDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(addAssignmentViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addAssignmentViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
    }
    
    /*
     *  Function to initialize time pikcer property for timeTextField
     */
    func initTimePicker() {
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(addAssignmentViewController.timeChanged(timePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addAssignmentViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        timeTextField.inputView = timePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        
        // *****************************************
        //  The following line was comment out since
        //  it will end date picking upen each date
        //  selection
        //  3/17/2020 by Mengtao Tang
        // *****************************************
        //view.endEditing(true)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTextField.text = formatter.string(from: timePicker.date)
        
        // *****************************************
        //  The following line was comment out since
        //  it will end date picking upen each date
        //  selection
        //  3/17/2020 by Mengtao Tang
        // *****************************************
        //view.endEditing(true)
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirm(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
