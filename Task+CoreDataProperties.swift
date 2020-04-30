//
//  Task+CoreDataProperties.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/29/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var createTime: String?
    @NSManaged public var endTime: String?
    @NSManaged public var notification: Bool
    @NSManaged public var notificationAheadTime: NSDecimalNumber?
    @NSManaged public var status: Bool
    @NSManaged public var title: String?
    @NSManaged public var selfID: String?
    @NSManaged public var startTimeForCourse: String?
    @NSManaged public var notificationID: String?
    @NSManaged public var roomForCourse: String?

}
