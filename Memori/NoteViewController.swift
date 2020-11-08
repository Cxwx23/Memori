//
//  NoteViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/5/20.
//

import UIKit

class NoteViewController: UIViewController {
    
    
    @IBOutlet weak var textView: UITextView!
    var text: String = "text"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let note = Note()
        
        // this is not working yet
        print("title: \(note.title.description)")
        print("body: \(note.body.description)")
        print("count: \(note.count.description)")
        
        if note.title != Note.defualtTitle {
            note.title = "New Title"
            note.body = "New Body"
            note.count = 99
        }
    
        //  this does not seem to do anything
        textView.text = text
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.text = text
    }
    

}
