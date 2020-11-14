//
//  Note.swift
//  Memori
//
//  Created by Cole Warner on 11/6/20.
//

import UIKit

class Note : NSObject, Codable {
    var note: String
    
    init(note: String) {
        self.note = note

    }
}
