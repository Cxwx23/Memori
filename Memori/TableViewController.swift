//
//  TableViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/7/20.
//

import UIKit

class TableViewController: UITableViewController {
    
    //var noteList = NoteList()
    
    //  var data: [String] = ["string1", "string2", "string3", "string4"]
    
    //  var note: Note = Note()
    var notes: [Note] = []
    var lists: [List] = []
    
    //  notes[0] = "string1"    // this causes xcode to say I have multiple consecutive commands
    
    
    //  could be current note
    var currentItem: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        notes.append(Note(title: "Note 1", body: "Note Body 1"))
        notes.append(Note(title: "Note 2", body: "Note Body 2"))
        notes.append(Note(title: "Note 3", body: "Note Body 3"))
        notes.append(Note(title: "Note 4", body: "Note Body 4"))
        
        
        
        //  lists.append(List(title: "List 1"))
        //  lists.append(List(title: "List 2"))
        //  lists.append(List(title: "List 3"))
        //  lists.append(List(title: "List 4"))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //  return data.count
        return notes.count
    }
    

    // this function iterates through the array to populate the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)

        //  noteCell.textLabel?.text = data[indexPath.row]  // indexPath passes in the index of the cell currently being iterated
        noteCell.textLabel?.text = notes[indexPath.row].title

        return noteCell
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
        currentItem = notes[indexPath.row].title
        performSegue(withIdentifier: "showNote", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let noteViewController = segue.destination as? NoteViewController {
            noteViewController.text = currentItem
        }
    }
    

}
