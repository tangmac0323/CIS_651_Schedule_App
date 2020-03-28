//
//  CalendarVars.swift
//  Schedule
//
//  Created by Mengtao Tang on 3/20/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation


// declare the current date
let CalendarVars_Date  = Date()
let CalendarVars_Calendar = Calendar.current

// Retrieve the day/week/month/year from the current Calendar
let CalendarVars_Day = CalendarVars_Calendar.component(.day, from: CalendarVars_Date)
var CalendarVars_Weekday = CalendarVars_Calendar.component(.weekday, from: CalendarVars_Date) - 1
var CalendarVars_Month = CalendarVars_Calendar.component(.month, from: CalendarVars_Date) - 1
var CalendarVars_Year = CalendarVars_Calendar.component(.year, from: CalendarVars_Date)

