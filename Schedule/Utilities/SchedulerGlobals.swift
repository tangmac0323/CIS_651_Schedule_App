//
//  SchedulerConstants.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/27/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit
import KVKCalendar


// singleton class for calendar to maintain the current selected date
class SelectedDateGlobal {
    static let sharedInstance = SelectedDateGlobal()
    var selectDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter.date(from: "03.30.2020") ?? Date()
    }()
    
}

//
class MyDateManager {
    func DateToFormattedString(date : Date) -> String {
        /*
        var rtnStr = ""
        
        let year = date.year
        let month = date.month
        let day = date.day
        let hour = date.hour
        let min = date.minute
        let zone = "\(TimeZone.current.secondsFromGMT() / 3600):00"
        
        //2020-03-30T08:30:00+03:00
        */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateStr = dateFormatter.string(from: date)
        return dateStr

    }
    
    func FormattedToSimplified(datestr : String) -> String {
        var rtnStr = ""
        
        /*
        let year = date.year
        let month = date.month
        let day = date.day
        let hour = date.hour
        let min = date.minute
        */
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: datestr) {
            /*
            let year = date.year
            let month = date.month
            let day = date.day
            let hour = date.hour
            let min = date.minute
            
            rtnStr = "\(month)-\(day)-\(year) \(hour):\(min)"
             */
            let formatter = DateFormatter()
            
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.medium
            
            rtnStr = formatter.string(from: date)
        }
        
        
        
        
        return rtnStr
    }
    
    func DateToSimplifiedString(date : Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.medium
        
        return formatter.string(from: date)
    }
    
    func FormattedStringToDate(dateStr : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: dateStr)!
    }
    
    func CalcDateDiffByDateObject(toDate : Date, fromDate : Date) -> Double {
        
        let delta = toDate.timeIntervalSince(fromDate)
        
        return delta
    }
    
    func CalcDateDiffByDateStr(toDate: String, fromDate: String) -> Double {
        
        // convert date string into data object
        let dateObjA = FormattedStringToDate(dateStr: toDate)
        let dateObjB = FormattedStringToDate(dateStr: fromDate)
        
        return CalcDateDiffByDateObject(toDate: dateObjA, fromDate: dateObjB)
        
    }
    
    func SecondToDate(seconds : Double) -> [Int] {
        let sec = Int(seconds)
        
        let day = sec / (60 * 60 * 24)
        let dayModulo = sec % (60 * 60 * 24)
        
        let hour = dayModulo / (60 * 60)
        let hourModulo = dayModulo % (60 * 60)
        
        let mins = hourModulo / 60
        
        return [day, hour, mins]
        //return (sec/(60*60*24), sec/(60*60), sec/60)
        
    }
    
    
    
}

