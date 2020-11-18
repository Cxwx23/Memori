//
//  Task.swift
//  Memori
//
//  Created by Cole Warner on 11/9/20.
//

import UIKit

struct Task {
    var title: String
    var checklist: [String]
    var notes: String
    var dueDate: Date
    
    init(title: String, checklist: [String], notes: String, dueDate: Date) {
        self.title = title
        self.checklist = checklist
        self.notes = notes
        self.dueDate = dueDate
    }
    
    
}
