//
//  ListViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/7/20.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var listTextView: UITextView!
    //var list: List = List(title: "", checklist: [""])
    var listTitle: String = ""
    var checklist: [String] = [""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //  listTextView.text = list.title
        listTextView.text = listTitle
        for item in checklist {
            listTextView.text.append("\n" + item)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  This currently displays the title from the table view when the view appears after already having been loaded
        listTextView.text = listTitle
        for item in checklist {
            listTextView.text.append("\n" + item)
        }
    }
    

}
