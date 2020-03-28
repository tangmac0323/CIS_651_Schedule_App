//
//  DailyViewController.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/16.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var classTableView: UITableView!
    @IBOutlet weak var taskTableView: UITableView!
    
    var dates = ["d1", "d2", "d3"]
    var tasks = ["t1", "t2", "t3"]
    var details = ["de1", "de2", "de3"]
    
    var times = ["time1", "time2"]
    var classrooms = ["classroom1", "classroom2"]
    var courses = ["course1", "course2"]
    
    var selectIndex = -1
    var isCollapse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        currentDateLabel.text! = formatter.string(from: date)

        // Do any additional setup after loading the view.
        taskTableView.estimatedRowHeight = 130
        taskTableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == taskTableView {
            if self.selectIndex == indexPath.row && self.isCollapse == true {
                return 130
            }
            else {
                return 50
            }
        }
        else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView == classTableView) {
            return times.count
        }
        else {
            return dates.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == classTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyClassCell") as! DailyClassTableViewCell
            
            cell.timeLabel.text! = times[indexPath.row]
            cell.classroomLabel.text! = classrooms[indexPath.row]
            cell.courseLabel.text! = courses[indexPath.row]
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTaskCell") as! DailyTaskTableViewCell
            
            cell.dateLabel.text! = dates[indexPath.row]
            cell.taskLabel.text! = tasks[indexPath.row]
            cell.detailTextView.text! = details[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == taskTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            if selectIndex == indexPath.row {
                if self.isCollapse == false {
                    self.isCollapse = true
                }
                else {
                    self.isCollapse = false
                }
            }
            else {
                self.isCollapse = true
            }
            
            self.selectIndex = indexPath.row
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        
    }
    

}
