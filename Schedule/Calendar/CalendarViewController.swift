//
//  CalendarViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 3/20/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Variables outlet
    @IBOutlet weak var CollectionView_Calendar: UICollectionView!

    @IBOutlet weak var Label_CalendarTitle: UILabel!
    @IBOutlet weak var Button_Previous: UIButton!
    @IBOutlet weak var Button_Next: UIButton!
    
    // -------------- declare calendar component list  ----------------
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let WeekDays = ["Sunday","Monday","TuesDay","Wednesday","Thursday","Friday","Saturday"]
    var MonthDays = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    // -------------- declare calendar manager parameter  ----------------
    var CurrentMonth = String()
    var NumOfEmptyCell = Int()
    var NextNumOfEmptyCell = Int()
    var PreviousNumOfEmptyCell = 0
    var Direction = 0   // indicate the displayed month position compared to real-life month
    var PositionIndex = 0
    var dayCounter = 0
    
    // view load function
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initCalendar()
        
    }
    
    // Function to initialize the calendar on first load
    func initCalendar() {
        CollectionView_Calendar.delegate = self
        CollectionView_Calendar.dataSource = self
        
        CurrentMonth = Months[CalendarVars_Month]
        Label_CalendarTitle.text = "\(CurrentMonth) \(CalendarVars_Year)"
    }
    

    // *******************************************************************
    // Calendar Title Button Function
    // *******************************************************************
    
    // Button Onclick function for Previous Button in calendar title stack view
    @IBAction func Button_Onclick_Previous(_ sender: Any) {
        switch CurrentMonth {
        case "January":
            Direction = -1

            CalendarVars_Month = 11
            CalendarVars_Year -= 1
            
            
            self.SetupMonthdayByLeapYearChecking()
            self.CalcNumOfEmptyCellAtStart()
            
            // update the label display and refresh the view
            CurrentMonth = Months[CalendarVars_Month]
            Label_CalendarTitle.text = "\(CurrentMonth) \(CalendarVars_Year)"
            
            CollectionView_Calendar.reloadData()
            
        default:
            Direction = -1
            CalendarVars_Month -= 1
            
            self.CalcNumOfEmptyCellAtStart()
            
            // update the label display and refresh the view
            CurrentMonth = Months[CalendarVars_Month]
            Label_CalendarTitle.text = "\(CurrentMonth) \(CalendarVars_Year)"
            
            CollectionView_Calendar.reloadData()
        }
        
    }
    
    // Button Onclick function for Next Button in calendar title stack view
    @IBAction func Button_Onclick_Next(_ sender: Any) {
        switch CurrentMonth {
        case "December":
            Direction = 1

            CalendarVars_Month = 0
            CalendarVars_Year += 1
            
            self.SetupMonthdayByLeapYearChecking()
            self.CalcNumOfEmptyCellAtStart()
            
            // update the label display and refresh the view
            CurrentMonth = Months[CalendarVars_Month]
            Label_CalendarTitle.text = "\(CurrentMonth) \(CalendarVars_Year)"
            
            CollectionView_Calendar.reloadData()
        default:
            Direction = 1
            
            self.CalcNumOfEmptyCellAtStart()
            
            CalendarVars_Month += 1

            // update the label display and refresh the view
            CurrentMonth = Months[CalendarVars_Month]
            Label_CalendarTitle.text = "\(CurrentMonth) \(CalendarVars_Year)"
            
            CollectionView_Calendar.reloadData()
        }
    }
    
    
    //  Calculate the number of empty cell at the start of each month
    func CalcNumOfEmptyCellAtStart() {
        switch Direction{
        case 0:
            NumOfEmptyCell = CalendarVars_Weekday
            dayCounter = CalendarVars_Day
            while dayCounter>0 {
                NumOfEmptyCell = NumOfEmptyCell - 1
                dayCounter = dayCounter - 1
                if NumOfEmptyCell == 0 {
                    NumOfEmptyCell = 7
                }
            }
            if NumOfEmptyCell == 7 {
                NumOfEmptyCell = 0
            }
            PositionIndex = NumOfEmptyCell
        case 1...:
            NextNumOfEmptyCell = (PositionIndex + MonthDays[CalendarVars_Month])%7
            PositionIndex = NextNumOfEmptyCell
            
        case -1:
            PreviousNumOfEmptyCell = (7 - (MonthDays[CalendarVars_Month] - PositionIndex)%7)
            if PreviousNumOfEmptyCell == 7 {
                PreviousNumOfEmptyCell = 0
            }
            PositionIndex = PreviousNumOfEmptyCell
        default:
            fatalError()
        }
    }
    
    // Calculate the month days basing on leap years
    func SetupMonthdayByLeapYearChecking(){
        // check if the year%4 == 0
        if (CalendarVars_Year%4 == 0){
            // check if year%100 != 0
            if (CalendarVars_Year%100 != 0){
                MonthDays[1] = 29
            }
        }
        else{
            MonthDays[1] = 28
        }
    }
    
    // *******************************************************************
    // Collection view adapation function
    // *******************************************************************
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return MonthDays[CalendarVars_Month] + NumOfEmptyCell
        case 1:
            return MonthDays[CalendarVars_Month] + NextNumOfEmptyCell
        case -1:
            return MonthDays[CalendarVars_Month] + PreviousNumOfEmptyCell
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCollectionViewCell
        
        cell.backgroundColor = UIColor.clear
        
        cell.Label_CalendarCell.textColor = UIColor.black
        
        cell.View_DateBackground.isHidden = true
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        // check if the cell needs to be hidden
        switch Direction {
        case 0:
            cell.Label_CalendarCell.text = "\(indexPath.row + 1 - NumOfEmptyCell)"
        case 1:
            cell.Label_CalendarCell.text = "\(indexPath.row + 1 - NextNumOfEmptyCell)"
        case -1:
            cell.Label_CalendarCell.text = "\(indexPath.row + 1 - PreviousNumOfEmptyCell)"
        default:
            fatalError()
        }
        
        if Int(cell.Label_CalendarCell.text!)! < 1{ //here we hide the negative numbers or zero
            cell.isHidden = true
        }
        
        // set weekend days color
        switch indexPath.row {
        case 0,6,7,13,14,20,21,27,28,34,35:
            if Int(cell.Label_CalendarCell.text!)! > 0 {
                cell.Label_CalendarCell.textColor = UIColor.lightGray
            }
        default:
            break
        }
        if CurrentMonth == Months[CalendarVars_Calendar.component(.month, from: CalendarVars_Date) - 1] && CalendarVars_Year == CalendarVars_Calendar.component(.year, from: CalendarVars_Date) && indexPath.row + 1 - NumOfEmptyCell == CalendarVars_Day{
            cell.View_DateBackground.isHidden = false
            cell.DrawBackground()
            
        }
        return cell
    }
    
    
    // add tap gesture to each cell of the collection view
    
}
