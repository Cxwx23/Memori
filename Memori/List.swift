//
//  List.swift
//  Memori
//
//  Created by Cole Warner on 11/6/20.
//

import UIKit

class List: NSObject, Codable {
    var title: String
    //  var checklist: [String]
    var checklist: [ListItem]
    //  var checklistItems: [ListItem]
    
    init(title: String, checklist: [ListItem]) {  // , checklistItems: [ListItem])
        self.title = title
        self.checklist = checklist
        //self.checklistItems = checklistItems
    }
}


class ListItem: NSObject, Codable {
    var item: String
    var isChecked: Bool
    
    init(item: String, isChecked: Bool) {
        self.item = item
        self.isChecked = isChecked
    }
}

