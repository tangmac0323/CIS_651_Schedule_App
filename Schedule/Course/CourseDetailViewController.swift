//
//  CourseDetailViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class CourseDetailViewController : UIViewController {
    
    // declare outlets from story board
    @IBOutlet weak var College_Label: UILabel!
    @IBOutlet weak var SubjectArea_Label: UILabel!
    @IBOutlet weak var Course_Label: UILabel!
    @IBOutlet weak var OnlineType_Label: UILabel!
    @IBOutlet weak var SectionID_Label: UILabel!
    @IBOutlet weak var Date_Label: UILabel!
    @IBOutlet weak var ClassTime_Label: UILabel!
    @IBOutlet weak var Room_Label: UILabel!
    @IBOutlet weak var Instructor_Label: UILabel!
    @IBOutlet weak var Notification_Switch: UISwitch!
    
    @IBOutlet weak var Note_TextView: UITextView!
    
    @IBOutlet weak var Delete_Button: UIButton!
    
    // declare variable for pass in value
    var courseTitle : String?
    var courseObj: Course?
    
    let coredataRef = PersistenceManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initLabels()
        loadDataFromCoredataObject(course: self.courseObj)
    }
    
    // *********************************************************************************
    // initialize labels
    // *********************************************************************************
    func initLabels() {
        College_Label.text = ""
        SubjectArea_Label.text = ""
        Course_Label.text = ""
        OnlineType_Label.text = ""
        SectionID_Label.text = ""
        Date_Label.text = ""
        ClassTime_Label.text = ""
        Room_Label.text = ""
        Instructor_Label.text = ""
        
        Note_TextView.isEditable = false
        Note_TextView.text = ""
    }
    
    // *********************************************************************************
    // load data from coredata object
    // *********************************************************************************
    func loadDataFromCoredataObject(course: Course?) {
        
        // check if the object exist
        if course == nil {
            return
        }
        
        if let course = course {
            // fetch the data from the object
            College_Label.text = (course.college == "") ? "N/A" : course.college!
            SubjectArea_Label.text = (course.subjectArea == "") ? "N/A" : course.subjectArea!
            Course_Label.text = (course.course == "") ? "N/A" : course.course!
            OnlineType_Label.text = (course.onlineType == "") ? "N/A" : course.onlineType!
            SectionID_Label.text = (course.sectionID == "") ? "N/A" : course.sectionID!
            Date_Label.text = self.constructDateLabelFromCoredataObject(course: course)
            ClassTime_Label.text = self.constructTimeLabelFromCoredataObject(course: course)
            Room_Label.text = (course.room == "") ? "TBA" : course.room!
            Instructor_Label.text = (course.instructor == "") ? "TBA" : course.instructor!
            Notification_Switch.isOn = course.notification
            Note_TextView.text = course.content
        }
        
    }
    
    // *********************************************************************************
    // construct date label
    // *********************************************************************************
    func constructDateLabelFromCoredataObject(course: Course) -> String {
        var dateLabel = ""
        let startDate = (course.startDate == "") ? "TBA" : course.startDate!
        let endDate = (course.endDate == "") ? "TBA" : course.endDate!
        
        dateLabel = "\(startDate)-\(endDate)"

        return dateLabel
    }
    
    // *********************************************************************************
    // construct time label
    // *********************************************************************************
    func constructTimeLabelFromCoredataObject(course: Course) -> String {
        var timeLabel = ""
        let startTime = (course.endTime == "") ? "TBA" : course.endTime!
        let endTime = (course.endTime == "") ? "TBA" : course.endTime!
        let weekdays = (course.weekdays == "") ? "TBA" : course.weekdays!
        
        timeLabel = "\(weekdays) \(startTime)-\(endTime)"
        
        return timeLabel
    }
    
    // *********************************************************************************
    // delete the course
    // *********************************************************************************

    @IBAction func DeleteButton_Tapped(_ sender: Any) {
        if let object = self.courseObj {
            self.coredataRef.context.delete(object)
        }
        else{
            print("object not exist")
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}
