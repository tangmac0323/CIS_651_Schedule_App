//
//  WeeklyViewController.swift
//  KVKCalendar
//
//  Created by Mengtao Tang on 3/20/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit
import KVKCalendar

final class WeeklyViewController: UIViewController {
    
    //private var passInDateStr = "03.30.2020"
    
    private var events = [Event]()
    private var tasks = [Task]()
    private var courses = [Course]()
    
    // *********************************************************************************
    // initialize with core data persistence
    // *********************************************************************************
    let coredataRef = PersistenceManager.shared
    
    var selectDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy"
        return Date()
        //return formatter.date(from : self)
    }()
    
    //var selectDate = SelectedDate.sharedInstance.selectDate
    
    private lazy var todayButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(today))
        button.tintColor = .red
        return button
    }()
    
    private lazy var style: Style = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.month.isHiddenSeporator = true
            style.timeline.widthTime = 40
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
        } else {
            style.timeline.widthEventViewer = 500
        }
        style.timeline.startFromFirstEvent = false
        style.followInSystemTheme = true
        style.timeline.offsetTimeY = 80
        style.timeline.offsetEvent = 3
        style.timeline.currentLineHourWidth = 40
        style.allDay.isPinned = true
        style.startWeekDay = .sunday
        style.timeHourSystem = .twelveHour
        style.event.isEnableMoveEvent = true
        return style
    }()
    
    
    private lazy var calendarView: CalendarView = {
        
        /*
        print("View Frame:")
        print(view.frame)
        
        print("Safe Area Frame")
        print(view.safeAreaLayoutGuide.layoutFrame)
        */
        
        let calendar = CalendarView(frame: view.frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    
    
    private lazy var segmentedControl: UISegmentedControl = {
        let array: [CalendarType]
        if UIDevice.current.userInterfaceIdiom == .pad {
            array = CalendarType.allCases
        } else {
            array = CalendarType.allCases.filter({ $0 != .year })
        }
        let control = UISegmentedControl(items: array.map({ $0.rawValue.capitalized }))
        control.tintColor = .red
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
        return control
    }()
    
    private lazy var eventViewer: WeeklyEventViewer = {
        let view = WeeklyEventViewer(frame: CGRect(x: 0, y: 0, width: 500, height: calendarView.frame.height))
        return view
    }()
    
    // ******************************************
    //  viewDidLoad function
    // ******************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(calendarView)
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = todayButton
        
        calendarView.addEventViewToDay(view: eventViewer)
        
        loadEvents { [unowned self] (events) in
            self.events = events
            self.calendarView.reloadData()
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(calendarView)
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = todayButton
        
        calendarView.addEventViewToDay(view: eventViewer)
        
        */
        
        loadEvents { [unowned self] (events) in
            self.events = events
            self.calendarView.reloadData()
        }

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // get the size of the tab bar
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        //var myFrame = view.frame
        //myFrame.size.height -= tabBarHeight!
        //myFrame.origin.x += 100
        //myFrame.origin.y += tabBarHeight!
        
        //var frame = view.safeAreaLayoutGuide.layoutFrame
        var frame = view.frame
        frame.origin.y += navBarHeight!
        calendarView.reloadFrame(frame)
        
        
    }
    
    @objc func today(sender: UIBarButtonItem) {
        calendarView.scrollToDate(date: Date())
    }
    
    @objc func switchCalendar(sender: UISegmentedControl) {
        let type = CalendarType.allCases[sender.selectedSegmentIndex]
        calendarView.set(type: type, date: selectDate)
        calendarView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        loadEvents { [unowned self] (events) in
            self.events = events
            self.calendarView.reloadData()
        }
    }
}

extension WeeklyViewController: CalendarDelegate {
    func didChangeEvent(_ event: Event, start: Date?, end: Date?) {
        var eventTemp = event
        guard let startTemp = start, let endTemp = end else { return }
        
        let startTime = timeFormatter(date: startTemp)
        let endTime = timeFormatter(date: endTemp)
        eventTemp.start = startTemp
        eventTemp.end = endTemp
        eventTemp.text = "\(startTime) - \(endTime)\n new time"
        
        if let idx = events.firstIndex(where: { $0.compare(eventTemp) }) {
            events.remove(at: idx)
            events.append(eventTemp)
            calendarView.reloadData()
        }
    }
    
    func didAddEvent(_ date: Date?) {
        //print(date)
    }
    
    func didSelectDate(_ date: Date?, type: CalendarType, frame: CGRect?) {
        selectDate = date ?? Date()
        calendarView.reloadData()
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        print(type, event)
        switch type {
        case .day:
            eventViewer.text = event.text
        default:
            break
        }
    }
    
    func didSelectMore(_ date: Date, frame: CGRect?) {
        print(date)
    }
    
    func eventViewerFrame(_ frame: CGRect) {
        eventViewer.reloadFrame(frame: frame)
    }
}

extension WeeklyViewController: CalendarDataSource {
    func eventsForCalendar() -> [Event] {
        return events
    }
}

extension WeeklyViewController {
    
    // *************************************************
    //  TODO:
    //  Create corresponding database to import events
    //  The JSON events is for test/demo
    // *************************************************
    func loadEvents(completion: ([Event]) -> Void) {
        
        var events = [Event]()
        
        // generate regular task
        let taskList = coredataRef.getTaskList()
        for task in taskList {
            // generate weekly task
            let weeklyTask = self.convertTaskToWeeklyTask(task: task)
            events.append(convertTaskToEvent(task: weeklyTask))
        }
        
        // generate course task
        let courseList = coredataRef.getCourseList()
        for course in courseList {
            
            // generate course task for each course
            let courseTaskList = convertCourseToTaskList(course: course)
            
            // generate event for each course task
            for courseTask in courseTaskList {
                events.append(convertTaskToEvent(task: courseTask))
            }
        }
        
        
        
        completion(events)
    }
    
    func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.timeHourSystem == .twelveHour ? "h:mm a" : "HH:mm"
        return formatter.string(from: date)
    }
    
    func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
}

extension WeeklyViewController: UIPopoverPresentationControllerDelegate {
    
}

struct ItemData: Decodable {
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: CodingKeys.data)
    }
}

struct Item: Decodable {
    let id: String
    let title: String
    let start: String
    let end: String
    let color: UIColor
    let colorText: UIColor
    let files: [String]
    let allDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case start
        case end
        case color
        case colorText = "text_color"
        case files
        case allDay = "all_day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        start = try container.decode(String.self, forKey: CodingKeys.start)
        end = try container.decode(String.self, forKey: CodingKeys.end)
        allDay = try container.decode(Int.self, forKey: CodingKeys.allDay) != 0
        files = try container.decode([String].self, forKey: CodingKeys.files)
        let strColor = try container.decode(String.self, forKey: CodingKeys.color)
        color = UIColor.hexStringToColor(hex: strColor)
        let strColorText = try container.decode(String.self, forKey: CodingKeys.colorText)
        colorText = UIColor.hexStringToColor(hex: strColorText)
    }
}

extension UIColor {
    static func hexStringToColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0)
        )
    }
}


// MARK: - Weekly View Model

extension WeeklyViewController {
    
    // *********************************************************************************
    // initialize with core data persistence
    // *********************************************************************************
    func convertTaskToEvent(task: WeeklyTask) -> Event {
        let formatter = MyDateManager()
        
        var event = Event()
        event.id = task.selfID!
        
        
        event.end = formatter.FormattedStringToDate(dateStr: task.endTime!)
        
        let endTime = timeFormatter(date: event.end)
        
        event.isAllDay = false
        event.isContainsFile = false
        event.textForMonth = task.title!
        
        // calculate the start time using ahead notification
        if task.category == EventConstants.EventCategory.Task {
            event.start = CalcNotificationDate(task: task)
            event.text = "\(event.textForMonth) due at\n\(endTime)"
        }
        // course
        else {
            event.start = formatter.FormattedStringToDate(dateStr: task.startTimeForCourse!)
            let startTime = timeFormatter(date: event.start)
            event.eventData = task.content!
            event.text = "\(startTime) - \(endTime)\n\(event.textForMonth)\n\(task.roomForCourse!)"
        }
        
        return event
    }
    
    // *********************************************************************************
    // calculate the notification date
    // *********************************************************************************
    func CalcNotificationDate(task : WeeklyTask) -> Date {
        let formatter = MyDateManager()
        let endDate = formatter.FormattedStringToDate(dateStr: task.endTime!)
        let notificationDate = endDate - Double(task.notificationAheadTime!)
        return notificationDate
    }
    
    // *********************************************************************************
    // covert the course object to weekly task object list
    // *********************************************************************************
    func convertCourseToTaskList(course: Course) -> [WeeklyTask] {
        
        var taskList: [WeeklyTask] = []
        
        // check if attribute exist
        if course.startDate == "" || course.endDate == "" {
            return taskList
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let startDate = formatter.date(from: course.startDate!)
        let endDate = formatter.date(from: course.endDate!)
        
        // generate the Date list by weekdays from the course
        let dateList = self.getWeekdayList(startDate: startDate, endDate: endDate, weekdays: course.weekdays, startTime: course.startTime)
        
        // loop the date list and generate corresponding Task objects
        for dateObj in dateList {
            var task = WeeklyTask()
            
            // assign object ID
            //task.selfID = task.objectID.uriRepresentation().absoluteString
            task.selfID = course.objectID.uriRepresentation().absoluteString
            
            // assign end time
            let taskEndDate = self.timeConverter(date: dateObj, time: course.endTime)
            let myFormatter = MyDateManager()
            let taskEndDateStr = myFormatter.DateToFormattedString(date: taskEndDate)
            task.endTime = taskEndDateStr
            
            // assign start time
            task.startTimeForCourse = myFormatter.DateToFormattedString(date: dateObj)
            
            // assign trival
            task.title = course.course
            task.category = EventConstants.EventCategory.Course
            
            // construct block str
            task.roomForCourse = course.room
            
            // append to task list
            taskList.append(task)
            
        }
        
        return taskList
        
    }
    
    // *********************************************************************************
    // covert the task obejct to weekly task
    // *********************************************************************************
    func convertTaskToWeeklyTask(task: Task) -> WeeklyTask {
        var weeklyTask = WeeklyTask()
        
        weeklyTask.category = task.category
        //weeklyTask.content = task.content
        weeklyTask.createTime = task.createTime
        weeklyTask.endTime = task.endTime
        weeklyTask.notification = task.notification
        weeklyTask.notificationAheadTime = Int(truncating: task.notificationAheadTime!)
        weeklyTask.notificationID = task.notificationID
        weeklyTask.roomForCourse = task.roomForCourse
        weeklyTask.selfID = task.selfID
        weeklyTask.startTimeForCourse = task.startTimeForCourse
        weeklyTask.status = task.status
        weeklyTask.title = task.title
        
        return weeklyTask
    }
    
    
    // *********************************************************************************
    // input is startTime/endTime e.g. 13:50
    // output is a Date with formatted string: Date + "T" + time + "00:00"
    // *********************************************************************************

    func timeConverter(date: Date? ,time: String?) -> Date {
        
        if time == nil || date == nil {
            return Date()
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'"
        let dateStr = formatter.string(from: date!)
        let timeStr = time!+":00+00:00"
        let str = dateStr + timeStr
        
        //convert formatted string back to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: str)!
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
}

struct WeeklyTask {
    
    init() {
        selfID = ""
        startTimeForCourse = ""
        endTime = ""
        title = ""
        category = ""
        content = ""
        notificationAheadTime = 0
        notificationID = ""
        createTime = ""
        roomForCourse = ""
    }
    
    var selfID : String?
    var startTimeForCourse: String?
    var endTime: String?
    var title: String?
    var category: String?
    var content: String?
    var notification: Bool = false
    var notificationAheadTime: Int?
    var notificationID: String?
    var createTime: String?
    var status: Bool = false
    var roomForCourse: String?
    
}
