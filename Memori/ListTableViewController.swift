//
//  ListTableViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/9/20.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    //var noteList = NoteList()
    
    //  var data: [String] = ["string1", "string2", "string3", "string4"]
    
    //  var note: Note = Note()
    //var notes: [Note] = []
    var lists: [List] = []
    var checklist: [String] = [""]
    
    //  notes[0] = "string1"    // this causes xcode to say I have multiple consecutive commands
    
    
    //  could be current note
    //var currentItem: String = ""
    //var currentItem: String = ""
    //  var currentItem: List = List(title: "", checklist: [""])
    var currentItem: String = ""
    var currentItemChecklist: [String] = [""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let checklist1: [String] = ["do something 1", "do something 2"]
        lists.append(List(title: "List 1", checklist: checklist1))
        let checklist2: [String] = ["do something 3", "do something 4"]
        lists.append(List(title: "List 2", checklist: checklist2))
        let checklist3: [String] = ["do something 5", "do something 6"]
        lists.append(List(title: "List 3", checklist: checklist3))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return lists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listCell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        // Configure the cell...
        listCell.textLabel?.text = lists[indexPath.row].title

        return listCell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  currentItem = data[indexPath.row]
        //currentItem = lists[indexPath.row].title + "\n"
        currentItem = lists[indexPath.row].title
        currentItemChecklist = lists[indexPath.row].checklist
           
        print("indexPath = \(indexPath)")
        //  currentItem = notes[indexPath.row]
        performSegue(withIdentifier: "showList", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let listViewController = segue.destination as? ListViewController {
            listViewController.listTitle = currentItem
            listViewController.checklist = currentItemChecklist
        }
    }
    

}
