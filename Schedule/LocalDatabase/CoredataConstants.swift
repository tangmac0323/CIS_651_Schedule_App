//
//  CoredataConstants.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit


struct TaskCoredataConstants {
    static let EntityTitle = "Task"
    
    static let EndTime = "endTime"
    static let Category = "category"
    static let Content = "content"
    static let CreateTime = "createTime"
    static let Notification = "notification"
    static let NotificationAheadTime = "notificationAheadTime"
    static let Status = "status"
    static let Title = "title"
    static let SelfID = "selfID"
    static let StartTimeForCourse = "startTimeForCourse"
    
    static let NotificationAheadTimeInSec = 1800.0
    
    
}

struct CourseCoredataConstants {
    static let EntityTitle = "Course"
}


struct EventConstants {
    struct EventCategory {
        static let Task = "Task"
        static let Course = "Course"
    }
    
    struct EventColor {
        static let Task = UIColor.green
        static let Course = UIColor.yellow
    }
}

