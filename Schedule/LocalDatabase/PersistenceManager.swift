//
//  PersistenceManager.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {
    
    private init() {}
    
    // create a singleton
    static let shared = PersistenceManager()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        
        let container = NSPersistentCloudKitContainer(name: "EventsDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("save successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // *********************************************************************************
    // extract task from coredata
    // *********************************************************************************
    
    func getTaskList() -> [Task]{
        
        // init the list
        var TaskList : [Task] = []
        
        guard let tasks = try! self.context.fetch(Task.fetchRequest()) as? [Task]
            else { return [] }
        tasks.forEach { (task) in
            TaskList.append(task)
        }
        
        return TaskList
        
    }
    
    // *********************************************************************************
    // extract task from coredata
    // *********************************************************************************
    
    func getTaskListByCategory(category : String) -> [Task]{
        
        // init the list
        var TaskList : [Task] = []
        
        let fetchRequest = NSFetchRequest<Task>(entityName: TaskCoredataConstants.EntityTitle)

        fetchRequest.predicate = NSPredicate(format: "category == %@", category)

        do {
            let tasks = try self.context.fetch(fetchRequest)
            tasks.forEach { (task) in
                TaskList.append(task)
            }
        }
        catch let error as NSError {
            
        }
        /*
        guard let tasks = try! self.context.fetch(fetchRequest) as? [Task]
            else { return [] }
        tasks.forEach { (task) in
            TaskList.append(task)
        }
        */
        return TaskList
        
    }
    
    // *********************************************************************************
    // check if course exist
    // *********************************************************************************
    func isCourseAlreadyInList(courseStr: String) -> Bool {
        
        // lowercase the course
        let course = courseStr.lowercased()
        //var CourseList : [Course] = []
        //bool isExist = false
        
        // fetch from the data base
        let fetchRequest = NSFetchRequest<Course>(entityName: CourseCoredataConstants.EntityTitle)
        fetchRequest.predicate = NSPredicate(format: "course == %@", course)
        
        do {
            let courses = try self.context.fetch(fetchRequest)
            // check the request fetch count
            if courses.count == 0 {
                return false
            }
            else {
                return true
            }

        }
        catch let error as NSError {
            return true
        }
    }
    
    // *********************************************************************************
    // extract course from coredata
    // *********************************************************************************
    
    func getCourseList() -> [Course]{
        
        // init the list
        var CourseList : [Course] = []
        
        guard let courses = try! self.context.fetch(Course.fetchRequest()) as? [Course]
            else { return [] }
        courses.forEach { (course) in
            CourseList.append(course)
        }
        
        return CourseList
        
    }
    
    
}
