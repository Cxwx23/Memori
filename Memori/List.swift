//
//  List.swift
//  Memori
//
//  Created by Cole Warner on 11/6/20.
//

import UIKit

class List: NSObject, Codable {
    var title: String
    var checklist: [String]
    
    init(title: String, checklist: [String]) {
        self.title = title
        self.checklist = checklist
    }
}

