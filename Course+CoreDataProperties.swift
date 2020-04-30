//
//  Course+CoreDataProperties.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/29/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//
//

import Foundation
import CoreData


extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var subjectArea: String?
    @NSManaged public var college: String?
    @NSManaged public var content: String?
    @NSManaged public var course: String?
    @NSManaged public var endDate: String?
    @NSManaged public var endTime: String?
    @NSManaged public var instructor: String?
    @NSManaged public var notification: Bool
    @NSManaged public var room: String?
    @NSManaged public var sectionID: String?
    @NSManaged public var startDate: String?
    @NSManaged public var startTime: String?
    @NSManaged public var unit: Double
    @NSManaged public var weekdays: String?
    @NSManaged public var selfID: String?
    @NSManaged public var onlineType: String?
    @NSManaged public var notificationID: String?
    
    
}
