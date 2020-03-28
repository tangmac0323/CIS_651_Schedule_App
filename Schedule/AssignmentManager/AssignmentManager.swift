//
//  AssignmentManager.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/17.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation

struct Assignment {
    var deadline: Date?
    var title: String?
    var description: String?
}

class AssignmentManager {
    static let shared = AssignmentManager()
    private var assignment: Assignment?
    
    init() {
        
    }
    
    func getAssignment() -> Assignment {
        return assignment!
    }
    
    func setAssignment(assign: Assignment) {
        assignment?.deadline = assign.deadline
        assignment?.title = assign.title
        assignment?.description = assign.description
    }
}
