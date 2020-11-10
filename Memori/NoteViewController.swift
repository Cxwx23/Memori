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
    
        //  This currently displays the title and notes from the table view when the view loads the first time
        textView.text = text
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  This currently displays the title and notes from the table view when the view appears after already having been loaded
        textView.text = text
    }
    

}
