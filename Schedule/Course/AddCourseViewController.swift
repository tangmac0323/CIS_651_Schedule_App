//
//  AddCourseViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAnalytics
import CoreData

class AddCourseViewController : UIViewController {
    
    // declare outlets from storyboards
    @IBOutlet weak var Save_ButtonItem: UIBarButtonItem!
    @IBOutlet weak var Save_Button: UIButton!
    
    
    @IBOutlet weak var College_TextField: UITextField!
    @IBOutlet weak var SubjectArea_TextField: UITextField!
    @IBOutlet weak var CourseTitle_TextField: UITextField!
    @IBOutlet weak var ClassID_TextField: UITextField!
    @IBOutlet weak var SectionID_TextField: UITextField!
    @IBOutlet weak var OnlineType_TextField: UITextField!
    
    @IBOutlet weak var CourseError_Label: UILabel!
    @IBOutlet weak var StartDate_Label: UILabel!
    @IBOutlet weak var EndDate_Label: UILabel!
    @IBOutlet weak var WeekDays_Label: UILabel!
    @IBOutlet weak var ClassTime_Label: UILabel!
    @IBOutlet weak var Room_Label: UILabel!
    @IBOutlet weak var Instructor_Label: UILabel!
    @IBOutlet weak var OnlineReminder_Label: UILabel!
    
    @IBOutlet weak var Notification_Switch: UISwitch!
    @IBOutlet weak var Description_TextView: UITextView!
    
    
    let coredataRef = PersistenceManager.shared
    let firebaseManager = FirebaseManager()
    
    // varaibles for picker view action
    var currentTextField = UITextField()
    
    // variables for firebase access
    var selectedCourse : String?
    var selectedSection : String?
    var selectedOnlineType : String?
    var startTime : String?
    var endTime : String?
    var startDate : String?
    var endDate : String?
    var weekdays : String?
    var room : String?
    var instructor : String?
    var content: String?
    var subjectArea: String?
    
    
    //var collegeList = ["CS","CE","EE"]
    
    var sectionList : [String] = []
    var onlineTypeList : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createPickerViewForTextField()
        //enableDismissPickerViewFromTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        initVariable()
        initTextField()
        initLabels()
    }
    
    // *********************************************************************************
    // initialize tvariables
    // *********************************************************************************
    func initVariable() {
        selectedCourse = ""
        selectedSection = ""
        selectedOnlineType = ""
        startTime = ""
        endTime = ""
        startDate = ""
        endDate = ""
        weekdays = ""
        room = ""
        instructor = ""
        content = ""
        
        sectionList = []
        onlineTypeList = []
    }
    // *********************************************************************************
    // initialize textfield
    // *********************************************************************************
    func initTextField() {
        
        self.Description_TextView.text = ""
        
        self.CourseTitle_TextField.text = ""
        self.ClassID_TextField.text = ""
        self.SubjectArea_TextField.text = ""
        self.SectionID_TextField.text = ""
        self.College_TextField.text = ""
        self.OnlineType_TextField.text = ""

        
        self.CourseTitle_TextField.placeholder = "course title"
        self.ClassID_TextField.placeholder = "class ID"
        self.SubjectArea_TextField.placeholder = "subject are"
        self.SectionID_TextField.placeholder = "section ID"
        self.College_TextField.placeholder = "college"
        self.OnlineType_TextField.placeholder = "async/sync"
        
        
        self.College_TextField.delegate = self
        self.SubjectArea_TextField.delegate = self
        self.CourseTitle_TextField.delegate = self
        self.ClassID_TextField.delegate = self
        self.SectionID_TextField.delegate = self
        self.OnlineType_TextField.delegate = self
        
        self.College_TextField.isUserInteractionEnabled = false
        self.College_TextField.backgroundColor = UIColor.lightGray
        
        self.SubjectArea_TextField.isUserInteractionEnabled = false
        self.SubjectArea_TextField.backgroundColor = UIColor.lightGray
        
        self.CourseTitle_TextField.isUserInteractionEnabled = true
        
        self.ClassID_TextField.isUserInteractionEnabled = false
        self.ClassID_TextField.backgroundColor = UIColor.lightGray
        
        self.SectionID_TextField.isUserInteractionEnabled = false
        self.SectionID_TextField.backgroundColor = UIColor.lightGray
        
        self.OnlineType_TextField.isUserInteractionEnabled = false
        self.OnlineType_TextField.backgroundColor = UIColor.lightGray
        
        self.Description_TextView.isUserInteractionEnabled = false
        self.Description_TextView.backgroundColor = UIColor.lightGray
        
        
        createPickerViewForTextField(textField: self.College_TextField)
        createPickerViewForTextField(textField: self.SubjectArea_TextField)
        //createPickerViewForTextField(textField: self.CourseTitle_TextField)
        createPickerViewForTextField(textField: self.ClassID_TextField)
        createPickerViewForTextField(textField: self.SectionID_TextField)
        createPickerViewForTextField(textField: self.OnlineType_TextField)
        
        enableDismissPickerViewFromTextField(textField: self.College_TextField)
        enableDismissPickerViewFromTextField(textField: self.SubjectArea_TextField)
        //enableDismissPickerViewFromTextField(textField: self.CourseTitle_TextField)
        enableDismissPickerViewFromTextField(textField: self.ClassID_TextField)
        enableDismissPickerViewFromTextField(textField: self.SectionID_TextField)
        enableDismissPickerViewFromTextField(textField: self.OnlineType_TextField)
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
        
        self.CourseError_Label.isHidden = true
        self.OnlineReminder_Label.isHidden = true
    }
    

    // *********************************************************************************
    // save the content to coredata base
    // *********************************************************************************
    func createCourse() {
        let course = Course(context: coredataRef.context)
        
        /*
        selectedCourse = ""
        selectedSection = ""
        selectedOnlineType = ""
        startTime = ""
        endTime = ""
        startDate = ""
        endDate = ""
        weekdays = ""
        room = ""
        instructor = ""
        content = ""
         */
        
        course.subjectArea = self.subjectArea
        course.college = self.College_TextField.text
        course.content = self.Description_TextView.text
        course.course = self.selectedCourse
        course.endDate = self.endDate
        course.endTime = self.endTime
        course.instructor = self.instructor
        course.notification = self.Notification_Switch.isOn
        course.onlineType = self.selectedOnlineType
        course.room = self.room
        course.sectionID = self.selectedSection
        course.selfID = course.objectID.uriRepresentation().absoluteString
        course.startDate = self.startDate
        course.startTime = self.startTime
        course.unit = 3.0
        course.weekdays = self.weekdays
        /*
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
        */
        
        coredataRef.saveContext()
    }
    
    @IBAction func SaveButton_Tapped(_ sender: Any) {
        createCourse()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}

// for picker view
extension AddCourseViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if currentTextField == College_TextField {
            return 0
            //return self.collegeList.count
        }
        else if currentTextField == SubjectArea_TextField {
            return 0
        }
        else if currentTextField == CourseTitle_TextField {
            return 0
        }
        else if currentTextField == ClassID_TextField {
            return 0
        }
        else if currentTextField == SectionID_TextField {
            return self.sectionList.count
        }
        else if currentTextField == OnlineType_TextField {
            return self.onlineTypeList.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if currentTextField == College_TextField {
            return ""
            //return self.collegeList[row]
        }
        else if currentTextField == SubjectArea_TextField {
            return ""
        }
        else if currentTextField == CourseTitle_TextField {
            return ""
        }
        else if currentTextField == ClassID_TextField {
            return ""
        }
        else if currentTextField == SectionID_TextField {
            return self.sectionList[row]
        }
        else if currentTextField == OnlineType_TextField {
            return self.onlineTypeList[row]
        }
        else {
            return "nothing"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentTextField == College_TextField {
            //self.selectedCollege = self.collegeList[row]
            //College_TextField.text = self.selectedCollege
        }
        else if currentTextField == SubjectArea_TextField {
            
        }
        else if currentTextField == CourseTitle_TextField {
            
        }
        else if currentTextField == ClassID_TextField {
            
        }
        else if currentTextField == SectionID_TextField {
            self.selectedSection = self.sectionList[row]
            SectionID_TextField.text = self.selectedSection
        }
        else if currentTextField == OnlineType_TextField {
            self.selectedOnlineType = self.onlineTypeList[row]
            OnlineType_TextField.text = self.selectedOnlineType
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
        self.CourseError_Label.isHidden = true
        
        
        if self.currentTextField == College_TextField {

        }
        else if self.currentTextField == SubjectArea_TextField {

        }
        else if self.currentTextField == CourseTitle_TextField {
            //self.SectionID_TextField.isUserInteractionEnabled = false
            //self.SectionID_TextField.backgroundColor = UIColor.lightGray
            //initVariable()
            initTextField()
            initLabels()
        }
        else if self.currentTextField == ClassID_TextField {
            
        }
        else if self.currentTextField == SectionID_TextField {
            
            // reset the online type text field
            self.OnlineType_TextField.text = ""
            self.OnlineType_TextField.placeholder = "async/sync"
            self.OnlineType_TextField.isUserInteractionEnabled = false
            self.OnlineType_TextField.backgroundColor = UIColor.lightGray
            
            if sectionList.count != 0 {
                self.SectionID_TextField.text = sectionList[0]
            }
        }
        else if self.currentTextField == OnlineType_TextField {
            if onlineTypeList.count != 0 {
                self.OnlineType_TextField.text = onlineTypeList[0]
            }
        }
        else {
            print("error")
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*********************** Editing Course Title *********************/
        if self.currentTextField == CourseTitle_TextField {
            
            // set the the selected college
            self.selectedCourse = CourseTitle_TextField.text
            
            // check if the course titlte is valid
            firebaseManager.retrieveCourseInfoByCourseTitle(courseTitle: self.currentTextField.text, CompletionHandler: { (document, sectionList, isValid) in
                
                // check if the course title is valid
                if isValid != true {
                    // show error message
                    self.CourseError_Label.isHidden = false
                    self.CourseError_Label.text = "Course not found"
                    return
                }
                    // set the picker list for section id
                else {
                    if let courseDict = document?.data() {
                        //if let sectionCollectionReference = courseDict[FirebaseConstants.CourseCollection.]{
                        self.sectionList = sectionList!

                        self.College_TextField.text = courseDict[FirebaseConstants.CourseCollection.College] as! String
                        self.SubjectArea_TextField.text = courseDict[FirebaseConstants.CourseCollection.SubjectArea] as! String
                        //}
                        
                        
                        self.SectionID_TextField.isUserInteractionEnabled = true
                        self.SectionID_TextField.backgroundColor = UIColor.white
                        
                        self.selectedCourse = self.CourseTitle_TextField.text
                        self.subjectArea = self.SubjectArea_TextField.text
                    }
                }
            })
        }
        /*********************** Editing Section *********************/
        else if self.currentTextField == SectionID_TextField {
            
            // set the selected section
            self.selectedSection = self.SectionID_TextField.text
            
            // check if the section is online
            firebaseManager.checkIfOnlineSectionByCourseBySection(courseTitle: self.selectedCourse, sectionID: self.selectedSection) { (onlineList, isOnline, isValid) in
                
                // check the query is valid
                if isValid != true {
                    return
                }
                else {
                    // check if it is online
                    /*********************** Load Data For Normal Section *********************/
                    if isOnline != true {
                        // extract data from the section
                        self.firebaseManager.retrieveNormalSectionInfoByCourseBySection(courseTitle: self.selectedCourse, sectionID: self.selectedSection) { (sectionData, isValid) in
                            let sectionData = sectionData!
                            
                            // set up the display
                            self.loadDataFromNormalSectionReference(sectionData: sectionData)
                            
                            // done
                            return
                            
                        }
                        
                    }
                    else{
                        self.onlineTypeList = onlineList!
                        //print(onlineList)
                        self.OnlineType_TextField.isUserInteractionEnabled = true
                        self.OnlineType_TextField.backgroundColor = UIColor.white
                    }
                }   // if is valid else
            }
            
        }
        /*********************** Load Data For Online Section *********************/
        else if self.currentTextField == OnlineType_TextField {
            
            
            // set the online type
            self.selectedOnlineType = self.OnlineType_TextField.text
            
            // retrieve and load the data by online type
            self.firebaseManager.retrieveOnlineSectionInforByCourseBySectionByOnlineType(courseTitle: self.selectedCourse, sectionID: self.selectedSection, onlineType: self.selectedOnlineType) { (sectionData, isValid) in
                
                // check if process successful
                if isValid != true {
                    return
                }
                // load the data
                else {
                    let sectionData = sectionData!
                    self.loadDataFromOnlineSectionReference(sectionData: sectionData)
                }
            }
            
        }
    }
    
    // *********************************************************************************
    // function to load partial data from online section before online type
    // *********************************************************************************
    func loadDataFromOnlineSectionReference(sectionData: [String: Any]){
        if let content = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Content] {
            self.content = content as! String
        }
        
        if let endDate = sectionData[FirebaseConstants.CourseCollection.SectionCollection.EndDate] {
            self.endDate = endDate as! String
        }
        
        if let endTime = sectionData[FirebaseConstants.CourseCollection.SectionCollection.EndTime] {
            self.endTime = endTime as! String
        }
        
        if let startDate = sectionData[FirebaseConstants.CourseCollection.SectionCollection.StartDate] {
            self.startDate = startDate as! String
        }
        
        if let startTime = sectionData[FirebaseConstants.CourseCollection.SectionCollection.StartTime] {
            self.startTime = startTime as! String
        }
        
        if let room = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Room] {
            self.room = room as! String
        }
        
        if let instructor = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Instructor] {
            self.instructor = instructor as! String
        }
        
        if let weekdays = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Weekdays] {
            self.weekdays = weekdays as! String
        }
        
        self.StartDate_Label.text = "From: \(self.startDate!)"
        self.EndDate_Label.text = "To: \(self.endDate!)"
        self.WeekDays_Label.text = "\(self.weekdays!)"
        self.ClassTime_Label.text = "\(self.startTime!) - \(self.endTime!)"
        self.Room_Label.text = "\(self.room!)"
        self.Instructor_Label.text = "\(self.instructor!)"
        self.Description_TextView.text = "\(self.content!)"
    }
    
    // *********************************************************************************
    // function to set up the labels from section dictionary
    // *********************************************************************************
    func loadDataFromNormalSectionReference(sectionData: [String: Any]) {
        if let content = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Content] {
            self.content = content as! String
        }
        
        if let endDate = sectionData[FirebaseConstants.CourseCollection.SectionCollection.EndDate] {
            self.endDate = endDate as! String
        }
        
        if let endTime = sectionData[FirebaseConstants.CourseCollection.SectionCollection.EndTime] {
            self.endTime = endTime as! String
        }
        
        if let startDate = sectionData[FirebaseConstants.CourseCollection.SectionCollection.StartDate] {
            self.startDate = startDate as! String
        }
        
        if let startTime = sectionData[FirebaseConstants.CourseCollection.SectionCollection.StartTime] {
            self.startTime = startTime as! String
        }
        
        if let room = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Room] {
            self.room = room as! String
        }
        
        if let instructor = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Instructor] {
            self.instructor = instructor as! String
        }
        
        if let weekdays = sectionData[FirebaseConstants.CourseCollection.SectionCollection.Weekdays] {
            self.weekdays = weekdays as! String
        }
        
        self.StartDate_Label.text = "From: \(self.startDate!)"
        self.EndDate_Label.text = "To: \(self.endDate!)"
        self.WeekDays_Label.text = "\(self.weekdays!)"
        self.ClassTime_Label.text = "\(self.startTime!) - \(self.endTime!)"
        self.Room_Label.text = "\(self.room!)"
        self.Instructor_Label.text = "\(self.instructor!)"
        self.Description_TextView.text = "\(self.content!)"
        
    }
    
    // hide the keyboard when click return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // *********************************************************************************
    // hide the keyboard on tap
    // *********************************************************************************
    func EnableHideKeyBoardOnTap() {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // *********************************************************************************
    // save the content to core data
    // *********************************************************************************
    
}

