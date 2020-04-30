//
//  FirebaseConstants.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/29/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation

struct FirebaseConstants {

    struct CourseCollection {
        static let CollectionTitle = "courses"
        
        static let College = "college"
        static let SubjectArea = "name"
        
        struct SectionCollection {
            
            static let CollectionTitle = "sections"
            
            static let Content = "content"
            static let Instructor = "instructor"
            static let Room = "room"
            static let EndDate = "endDate"
            static let StartDate = "startDate"
            static let Weekdays = "weekdays"
            static let EndTime = "endTime"
            static let StartTime = "startTime"
            
            static let OnlineRoom = "online"
            
            struct OnlineCollection {
                
                static let CollectionTitle = "onlineType"
                
                struct AsynchCollection {

                    static let CollectionTitle = "asynch"
                    
                    static let EndDate = "endDate"
                    static let StartDate = "startDate"
                    static let Weekdays = "weekdays"

                }
                
                struct SynchCollection {

                    static let CollectionTitle = "synch"
                    
                    static let EndDate = "endDate"
                    static let StartDate = "startDate"
                    static let Weekdays = "weekdays"
                    static let EndTime = "endTime"
                    static let StartTime = "startTime"

                }
            }
        }
        
    }

}
