//
//  AddCourseViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class AddCourseViewController : UIViewController {
    
    // declare outlets from storyboards
    @IBOutlet weak var Save_ButtonItem: UIBarButtonItem!
    @IBOutlet weak var Save_Button: UIButton!
    
    
    @IBOutlet weak var College_TextField: UITextField!
    @IBOutlet weak var SubjectArea_TextField: UITextField!
    @IBOutlet weak var CourseTitle_TextField: UITextField!
    @IBOutlet weak var ClassID_TextField: UITextField!
    @IBOutlet weak var SectionID_TextField: UITextField!
    
    @IBOutlet weak var StartDate_Label: UILabel!
    @IBOutlet weak var EndDate_Label: UILabel!
    @IBOutlet weak var WeekDays_Label: UILabel!
    @IBOutlet weak var ClassTime_Label: UILabel!
    @IBOutlet weak var Room_Label: UILabel!
    @IBOutlet weak var Instructor_Label: UILabel!
    
    @IBOutlet weak var Notification_Switch: UISwitch!
    
    
    // varaibles for picker view action
    var currentTextField = UITextField()
    var selectedCollege : String?
    var collegeList = ["CS","CE","EE"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createPickerViewForTextField()
        //enableDismissPickerViewFromTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        initTextField()
        initLabels()
    }
    
    
    // *********************************************************************************
    // initialize textfield
    // *********************************************************************************
    func initTextField() {
        
        self.College_TextField.delegate = self
        self.SubjectArea_TextField.delegate = self
        self.CourseTitle_TextField.delegate = self
        self.ClassID_TextField.delegate = self
        self.SectionID_TextField.delegate = self
        
        self.College_TextField.isUserInteractionEnabled = true
        
        self.SubjectArea_TextField.isUserInteractionEnabled = false
        self.SubjectArea_TextField.backgroundColor = UIColor.lightGray
        
        self.CourseTitle_TextField.isUserInteractionEnabled = false
        self.CourseTitle_TextField.backgroundColor = UIColor.lightGray
        
        self.ClassID_TextField.isUserInteractionEnabled = true
        
        self.SectionID_TextField.isUserInteractionEnabled = false
        self.SectionID_TextField.backgroundColor = UIColor.lightGray
        
        
        createPickerViewForTextField(textField: self.College_TextField)
        createPickerViewForTextField(textField: self.SubjectArea_TextField)
        createPickerViewForTextField(textField: self.CourseTitle_TextField)
        //createPickerViewForTextField(textField: self.ClassID_TextField)
        createPickerViewForTextField(textField: self.SectionID_TextField)
        
        enableDismissPickerViewFromTextField(textField: self.College_TextField)
        enableDismissPickerViewFromTextField(textField: self.SubjectArea_TextField)
        enableDismissPickerViewFromTextField(textField: self.CourseTitle_TextField)
        //enableDismissPickerViewFromTextField(textField: self.ClassID_TextField)
        enableDismissPickerViewFromTextField(textField: self.SectionID_TextField)
    }
    
    // *********************************************************************************
    // initialize labels
    // *********************************************************************************
    func initLabels() {
        StartDate_Label.text = ""
        EndDate_Label.text = ""
        WeekDays_Label.text = ""
        ClassTime_Label.text = ""
        Room_Label.text = ""
        Instructor_Label.text = ""
        Notification_Switch.isOn = false
    }
    

    
    
}

// for picker view
extension AddCourseViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if currentTextField == College_TextField {
            return self.collegeList.count
        }
        else if currentTextField == SubjectArea_TextField {
            print("subject")
            return 0
        }
        else if currentTextField == CourseTitle_TextField {
            print("course")
            return 0
        }
        else if currentTextField == ClassID_TextField {
            print("class id")
            return 0
        }
        else if currentTextField == SectionID_TextField {
            print("section id")
            return 0
        }
        else {
            print("error")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if currentTextField == College_TextField {
            return self.collegeList[row]
        }
        else if currentTextField == SubjectArea_TextField {
            print("subject")
            return ""
        }
        else if currentTextField == CourseTitle_TextField {
            print("course")
            return ""
        }
        else if currentTextField == ClassID_TextField {
            print("class id")
            return ""
        }
        else if currentTextField == SectionID_TextField {
            print("section id")
            return ""
        }
        else {
            return "nothing"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentTextField == College_TextField {
            self.selectedCollege = self.collegeList[row]
            College_TextField.text = self.selectedCollege
        }
        else if currentTextField == SubjectArea_TextField {
            print("subject")
            
        }
        else if currentTextField == CourseTitle_TextField {
            print("course")
            
        }
        else if currentTextField == ClassID_TextField {
            print("class id")
            
        }
        else if currentTextField == SectionID_TextField {
            print("section id")
            
        }
        else {
            
        }

    }
    
    // *********************************************************************************
    // set the input view of college textfied into pick view
    // *********************************************************************************
    func createPickerViewForTextField( textField : UITextField ) {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
    }
    
    func enableDismissPickerViewFromTextField( textField : UITextField ) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.endPickerView))
        
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        
    }
    
    @objc func endPickerView() {
        view.endEditing(true)
    }
    
}

// for textfield
extension AddCourseViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
        
        /*
        if self.currentTextField == College_TextField {
            print("college")
        }
        else if self.currentTextField == SubjectArea_TextField {
            print("subject")
        }
        else if self.currentTextField == CourseTitle_TextField {
            print("course")
            
        }
        else if self.currentTextField == ClassID_TextField {
            print("class id")
            
        }
        else if self.currentTextField == SectionID_TextField {
            print("section id")
            
        }
        else {
            print("error")
        }
        */
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.currentTextField == College_TextField {
            SubjectArea_TextField.isUserInteractionEnabled = true
            
            // build subject area list
        }
        else if self.currentTextField == SubjectArea_TextField {
            CourseTitle_TextField.isUserInteractionEnabled = true
            
            // build course list
        }
        else if self.currentTextField == ClassID_TextField {
            SectionID_TextField.isUserInteractionEnabled = true
            
            // build class id list
        }
    }
}

