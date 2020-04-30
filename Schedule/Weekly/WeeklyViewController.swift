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
        
        /*
        let decoder = JSONDecoder()
                
        guard let path = Bundle.main.path(forResource: "events", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
            let result = try? decoder.decode(ItemData.self, from: data) else { return }
        
        for (idx, item) in result.data.enumerated() {
            let startDate = self.formatter(date: item.start)
            let endDate = self.formatter(date: item.end)
            let startTime = self.timeFormatter(date: startDate)
            let endTime = self.timeFormatter(date: endDate)
            
            var event = Event()
            event.id = idx
            event.start = startDate
            event.end = endDate
            event.color = EventColor(item.color)
            event.isAllDay = item.allDay
            event.isContainsFile = !item.files.isEmpty
            event.textForMonth = item.title
            
            if item.allDay {
                event.text = "\(item.title)"
            } else {
                event.text = "\(startTime) - \(endTime)\n\(item.title)"
            }
            events.append(event)
        }
        */
        
        
        let taskList = coredataRef.getTaskList()
        for task in taskList {
            events.append(convertTaskToEvent(task: task))
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
    func convertTaskToEvent(task: Task) -> Event {
        let formatter = MyDateManager()
        
        var event = Event()
        event.id = task.selfID
        
        
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
            event.text = "\(startTime) - \(endTime)\n\(event.textForMonth)\n\(task.content!)"
        }
        return event
    }
    
    // *********************************************************************************
    // calculate the notification date
    // *********************************************************************************
    func CalcNotificationDate(task : Task) -> Date {
        let formatter = MyDateManager()
        let endDate = formatter.FormattedStringToDate(dateStr: task.endTime!)
        let notificationDate = endDate - Double(task.notificationAheadTime!)
        return notificationDate
    }
    
    // *********************************************************************************
    // get the color
    // *********************************************************************************
    
    
}


