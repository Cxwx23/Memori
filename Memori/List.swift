//
//  List.swift
//  Memori
//
//  Created by Cole Warner on 11/6/20.
//

import UIKit

class List: NSObject {
    static let defualtTitle = ""
    static let defaultList: [String] = []
    
    var title: String! = defualtTitle
    var list: [String?] = defaultList
    var count: Int = 0
    
    
    override init() {
        super.init()
        
    }
    
    init(title: String, count: Int, body: String, list: [String]) {
        self.title = title
        self.count = count
        self.list = list
        
    }
    
}
