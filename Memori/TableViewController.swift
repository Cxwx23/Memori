//
//  TableViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/7/20.
//

import UIKit

class TableViewController: UITableViewController {  //, UITableViewDataSource, UITableViewDelegate {
    //  Connects this table view controller to the table view for notes in the storyboard
    @IBOutlet var noteTable: UITableView!       //  this is new and may not be needed
    
    var notes: [String] = []
    //  var notes: [Note] = []
    // var note: Note = Note(note: "")

    var currentItem: String = ""
    var selectedRow = -1
    var newRowText: String = ""
    
    var fileURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations. Note: this was in the template for the class
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller - Note: this was in the template for the class
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // this was from before I added persistence
        //  notes.append(Note(note: "note 1"))
        //  notes.append(Note(note: "Note 2"))
        //  notes.append(Note(note: "Note 3"))
        
        
        //  sets the datasource for the noteTable object -
        noteTable.dataSource = self //  this is new and may not be needed
        noteTable.delegate = self   //  not yet sure what this does
        self.title = "Notes"
        
        //  creates the behavior of the button that will be used to add notes to the list on the table
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        //  creates the actual add note button in the upper right corner
        self.navigationItem.rightBarButtonItem = addNoteButton
        //  creates an edit button on the upper left hand corner
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        
        // accesses the document directory
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        // accesses the notes.txt file.
        fileURL = baseURL.appendingPathComponent("notes.txt")
        
        // load data from persistent storage
        load()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if selectedRow == -1 {
            return
        }
        
        //data[selectedRow] = newRowText
        notes[selectedRow] = newRowText
        
        if newRowText == "" {
            //data.remove(at: selectedRow)
            notes.remove(at: selectedRow)
        }
        
        noteTable.reloadData()
        
        save()
    }
    
    
    @objc func addNote() {
        
        //  Eliminates the ability to add rows while the table is in editing mode
        if noteTable.isEditing {
            return
        }
        
        //  creates a new note with the entered title and an empty note (for now)
        //let note: Note = Note(note: "")
        let note: String = ""
        
        //  inserts the note into the notes array
        notes.insert(note, at: 0)
        
        //  sets the value of index path to row 0 and section 0 - basically just adding the new note to the top of the table view
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        
        //  Adds the new row
        noteTable.insertRows(at: [indexPath], with: .automatic)
        noteTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        // go into detail view of note
        self.performSegue(withIdentifier: "showNote", sender: nil)
        
        //  save()
        
    }

    // MARK: - Table view data source

    //   This is set to 1 because we are only creating one section with multiple rows
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //  Returns the number of rows in the array holding the objects for the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    

    // this function iterates through the array to populate the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  indexPath is sort of like an iterator in C++ and returns an array of two ints representing the row and section of a given table cell
        let noteCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "noteCell")! //, for: indexPath)
        
        //  sets the text in my textLabel storyboard object to the value in the notes[].note string at indexPath.row
        //  noteCell.textLabel?.text = notes[indexPath.row].note
        noteCell.textLabel?.text = notes[indexPath.row]
        
        //  returns the cell at the current index
        return noteCell
        
    }
    
    // This function runs when the edit button is pressed
    override func setEditing(_ editing: Bool, animated: Bool) {
        //  You always have to call the constructore of the superclass in iOS
        super.setEditing(editing, animated: animated)
        //  calls the set editing class of the table object
        noteTable.setEditing(editing, animated: animated)
        //  calls the save function
        save()
    }
    
    //  removes a row when the delete button is pressed while in editing mode (after pressing the edit button
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //  removes the data from the notes array
        notes.remove(at: indexPath.row)
        //  removes the row from the table view
        noteTable.deleteRows(at: [indexPath], with: .fade)
        //  calls the save function
        //  save()
    }
        
    /*
    // Override to support conditional editing of the table view. - This was part of the template for the class
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.  - This was part of the template for the class
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
    // Override to support rearranging the table view.  - This was part of the template for the class
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.  - This was part of the template for the class
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    
    //  Gets the selected row from the variable 'indexPath', which is an array with 2 values (number of rows and number of sections
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var title: String = ""
        //var body: String = ""
    
        //  var note: String = ""
        
        //if notes[indexPath.row].title != nil {
            //title = notes[indexPath.row].title //?? ""
            //body = notes[indexPath.row].body //?? ""
        //  note = notes[indexPath.row].note
            //currentItem = title + "\n" + body
        //  currentItem = note
        //}

        //  print("indexPath = \(indexPath)")
        
        performSegue(withIdentifier: "showNote", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation  - This was part of the template for the class
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*
        if let noteViewController = segue.destination as? NoteViewController {
            noteViewController.text = currentItem
        }
        */
        
        let noteViewController = segue.destination as! NoteViewController
        
        selectedRow = noteTable.indexPathForSelectedRow!.row
        
        noteViewController.masterView = self
        
        noteViewController.setText(t: notes[selectedRow])
    }
    
    
    func save() {
       
        UserDefaults.standard.set(notes, forKey: "notes") //    <- this was the original way we did it which didn't save to a .txt.
        
        
        let a = NSArray(array: notes as [Any])
        
        do {
            try a.write(to: fileURL)
        } catch {
            print("error writing to file")
        }
 
        
    }
    
    
    func load() {
        // if the data is loaded into loaded data, call everything inside the if statement
        //if let loadedData:[Note] = UserDefaults.standard.value(forKey: "notes") as? [Note] {
        if let loadedData:[String] = UserDefaults.standard.value(forKey: "notes") as? [String] {
            
            notes = loadedData
            noteTable.reloadData()
            
        }
        
        //`var loadedData: [Note] = []
        
        //loadedData = NSArray(contentsOf:fileURL) as? [Note]
        
        /*
        if NSArray(contentsOf:fileURL) != nil {//as? [Note]? != nil {
        //if loadedData != nil {
            loadedData = NSArray(contentsOf:fileURL) as? [Note]
        
        //  if let loadedData: = NSArray(contentsOf:fileURL) as? [Note] {
            // set data equal to the data from persistent storage
            notes = loadedData
            // reload the table.
            noteTable.reloadData()
        }
        */
        
    }
}
