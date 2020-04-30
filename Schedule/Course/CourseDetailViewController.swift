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
    let notificationManager = NotificationManager.shared
    
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
    
    // *********************************************************************************
       // save all weekdays(class day) into a Date list
       // time interval: startDate ~ endDate
       // *********************************************************************************

       func getWeekdayList(startDate: Date?, endDate: Date?, weekdays: String?, startTime: String?) -> [Date] {
           
           if startDate == nil || endDate == nil || weekdays == nil || startTime == nil ||  weekdays == "" || startTime == "" {
               return []
           }
           
           //convert weekday patterns into numbers
           //targetWeekdays is the matched weekdays from startDate to endDate
           var targetWeekdays: [Int] = []
           switch weekdays! {
           case "M":
               targetWeekdays = [2]
           case "T":
               targetWeekdays = [3]
           case "W":
               targetWeekdays = [4]
           case "TH":
               targetWeekdays = [5]
           case "F":
               targetWeekdays = [6]
           case "Sa":
               targetWeekdays = [7]
           case "Su":
               targetWeekdays = [1]
           case "MW":
               targetWeekdays = [2, 4]
           case "TTH":
               targetWeekdays = [3, 5]
               
           default:
               targetWeekdays = []
           }
           
           var resultList: [Date] = []
           let calendar = Calendar.current
           let components = DateComponents(hour: 0, minute: 0, second: 0)
           
           let startDay = calendar.component(.weekday, from: startDate!)
           
           //if startDay is matched, add it into the result list
           if targetWeekdays.contains(startDay) {
               
               let formatter = DateFormatter()
               formatter.dateFormat = "yyyy-MM-dd'T'"
               let dateStr = formatter.string(from: startDate!)
               let timeStr = startTime!+":00+00:00"
               let str = dateStr + timeStr
               
               //convert formatted string back to date
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
               resultList.append(dateFormatter.date(from: str)!)
               
           }
           
           //iterate the dates from startDate to endDate
           calendar.enumerateDates(startingAfter: startDate!, matching: components, matchingPolicy: .nextTime) { (date, strict, stop) in
               if let date = date {
                   if date <= endDate! {
                       let weekday = calendar.component(.weekday, from: date)
                       
                       if targetWeekdays.contains(weekday) {
                           
                           let formatter = DateFormatter()
                           formatter.dateFormat = "yyyy-MM-dd'T'"
                           let dateStr = formatter.string(from: date)
                           let timeStr = startTime!+":00+00:00"
                           let str = dateStr + timeStr
                           
                           //convert formatted string back to date
                           let dateFormatter = DateFormatter()
                           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                           resultList.append(dateFormatter.date(from: str)!)
                       }
                   }
                   else {
                       stop = true
                   }
               }
           }
           
           return resultList
    }
    
    // *********************************************************************************
    // notification switch change
    // *********************************************************************************
    @IBAction func NotifySwitch_Changed(_ sender: Any) {
        
        // create a notification if is on
        if self.Notification_Switch.isOn {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let startDate = formatter.date(from: self.courseObj!.startDate!)
            let endDate = formatter.date(from: self.courseObj!.endDate!)
            
            if let courseObj = self.courseObj {
                // generate the Date list by weekdays from the course
                let dateList = self.getWeekdayList(startDate: startDate, endDate: endDate, weekdays: courseObj.weekdays, startTime: courseObj.startTime)
                
                // UPDATE Class count
                self.courseObj?.setValue(dateList.count, forKey: "classCount")
                self.coredataRef.saveContext()
                
                // create notification for each date with unique id
                var idCount = 0
                for dateObj in dateList {
                    //let myFormatter = MyDateManager()
                    //let dueDate = myFormatter.FormattedStringToDate(dateStr: self.selectedObject!.endTime!)
                    
                    
                    let notifyDate = dateObj - Double (60 * 10)
                    let notifyStr = "\(self.courseObj?.course)"
                    let notifyType = "Class"
                    let notifyID = "\(self.courseObj!.objectID.uriRepresentation().absoluteString)-\(idCount)"
                    
                    self.notificationManager.setNotify(date: notifyDate, str: notifyStr, type: notifyType, id: notifyID)
                    
                    idCount += 1    // increment id counter
                }
                
                //print("Current Notification: \(self.notificationManager.notifyCenter.accessibilityElementCount())")
                self.notificationManager.notifyCenter.getPendingNotificationRequests { (notList) in
                    print("Current pending notification after adding: \(notList.count)")
                }
                
            }
        }
        // remove the notification if is off
        else{
            // extract the class count of the course object
            let idCount = self.courseObj?.classCount as! Int
            for index in 1...idCount {
                let id_postfix = index - 1
                let notifyID = "\(self.courseObj!.objectID.uriRepresentation().absoluteString)-\(id_postfix)"
                self.notificationManager.removeNotify(id: notifyID)
                
            }
            
            self.notificationManager.notifyCenter.getPendingNotificationRequests { (notList) in
                print("Current pending notification after removing: \(notList.count)")
            }
            
        }

        
        //let dateList = self.getWeekdayList(startDate: course, endDate: <#T##Date?#>, weekdays: <#T##String?#>, startTime: <#T##String?#>)
        /*
        let myFormatter = MyDateManager()
        let dueDate = myFormatter.FormattedStringToDate(dateStr: self.selectedObject!.endTime!)
        let notifyDate = dueDate - Double (60 * 60 * 24)
        let notifyStr = "\(self.selectedObject!.title!)"
        let notifyType = "Task"
        let notifyID = selectedObject?.objectID.uriRepresentation().absoluteString
        
        // create a notification if is on
        if self.Notification_Switch.isOn {
            self.notificationManager.setNotify(date: notifyDate, str: notifyStr, type: notifyType, id: notifyID!)
        }
        // remove the notification if is off
        else{
            self.notificationManager.removeNotify(id: notifyID!)
        }
         */
    }
    
}
