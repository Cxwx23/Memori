//
//  ListViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/7/20.
//

import UIKit

class ListViewController: UIViewController {
    
    //  A connection to the text view ovject on the List View Object in the storyboard
    @IBOutlet weak var listTextView: UITextView!
    
    var listTitle: String = ""      //  Variable to hold the title of the checklist
    var checklist: [String] = [""]  //  Variable to hold the actual checklist
    var masterView:ListTableViewController!

    //  Runs when the List View runs for the first time
    override func viewDidLoad() {
        //  You always need to run the superclasses constructor in iOS development
        super.viewDidLoad()
        
        //  Adds the title of the checklist to the view
        listTextView.text = listTitle
        
        //  Loops through the checklist adding the items on the list to the view
        for item in checklist {
            listTextView.text.append("\n" + item)
        }
    }
    
    //  Runs whenever the view is selected, after the first time the view is loaded
    override func viewDidAppear(_ animated: Bool) {
        //  You always need to run the superclasses constructor in iOS development
        super.viewDidAppear(animated)
        
        //  This currently displays the title from the table view when the view appears after already having been loaded
        listTextView.text = listTitle
        
        //  Loops through the checklist adding the items on the list to the view
        for item in checklist {
            listTextView.text.append("\n" + item)
        }
    }
    
    func setListTitle(t:String) {
        
        listTitle = t
        
        if isViewLoaded {
            listTextView.text = t
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = listTextView.text
        //  print("calling resignFirstResponder")
        //  super.save()    // this did not work
        listTextView.resignFirstResponder()
    }
    

}
