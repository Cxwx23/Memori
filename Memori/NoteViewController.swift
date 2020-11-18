//
//  NoteViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/5/20.
//

import UIKit

//  This class handles changes to the individual note views
class NoteViewController: UIViewController {
    
    //  Connection to the text view area on the Note View
    @IBOutlet weak var textView: UITextView!
    var text: String = ""   //  A variable to hold the text to be displayed
    var masterView:TableViewController!

    //  Runs when the view loads for the first time
    override func viewDidLoad() {
        //  You always need to run the superclasses constructor in iOS development
        super.viewDidLoad()
    
        //  This displays the title and notes from the table view when the view loads the first time
        textView.text = text
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  print("calling becomeFirstResponder")
        textView.becomeFirstResponder()
    }
    
    //  Runs whenever the view is selected, after the first time it is loaded
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  This displays the title and notes from the table view when the view appears after already having been loaded
        textView.text = text
    }
    
    
    
    func setText(t:String) {
        
        text = t
        
        if isViewLoaded {
            textView.text = t
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = textView.text
        //  print("calling resignFirstResponder")
        //  super.save()    // this did not work
        textView.resignFirstResponder()
    }

}
