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
    
    var notes: [Note] = []
    var note: Note = Note(note: "")
    
    
    
    
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
        //notes.append(Note(title: "Note 1", body: "Note Body 1"))
        //notes.append(Note(title: "Note 2", body: "Note Body 2"))
        //notes.append(Note(title: "Note 3", body: "Note Body 3"))
        
        //  sets the datasource for the noteTable object -
        noteTable.dataSource = self //  this is new and may not be needed
        noteTable.delegate = self   //  not yet sure what this does
        
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
        notes[selectedRow] = note
        
        if newRowText == "" {
            //data.remove(at: selectedRow)
            notes.remove(at: selectedRow)
        }
        
        noteTable.reloadData()
        //table.reloadData()
        
        save()
    }
    
    
    
    
    
    @objc func addNote() {
        
        //  Eliminates the ability to add rows while the table is in editing mode
        if noteTable.isEditing {
            return
        }
        
        //let newTitle: String = "Item \(notes.count + 1)"
        
        //  creates a new note with the entered title and an empty note (for now)
        let note: Note = Note(note: "")
        
        //  inserts the note into the notes array
        notes.insert(note, at: 0)
        
        //  sets the value of index path to row 0 and section 0 - basically just adding the new note to the top of the table view
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        
        //  Adds the new row
        noteTable.insertRows(at: [indexPath], with: .automatic)
        
        
        noteTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        // go into detail view of note
        self.performSegue(withIdentifier: "showNote", sender: nil)
        
        save()
        
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
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)    //  do I not neew "with identifier??? Check this out after we attempt persistance
        
        // this is the way it was originally done in busynote
        //  let notecell: UITableViewCell = UITableViewCell()
        
        //if notes[indexPath.row].title != nil {
        noteCell.textLabel?.text = notes[indexPath.row].note
            
        //}
        //else {
        //    noteCell.textLabel?.text = ""
        //}
        

        return noteCell
        
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //  You always have to call the constructore of the superclass in iOS
        super.setEditing(editing, animated: animated)
        //  calls the set editing class of the table object
        noteTable.setEditing(editing, animated: animated)
        
        //  save()
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        notes.remove(at: indexPath.row)
        noteTable.deleteRows(at: [indexPath], with: .fade)
        save()
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
    
        var note: String = ""
        
        //if notes[indexPath.row].title != nil {
            //title = notes[indexPath.row].title //?? ""
            //body = notes[indexPath.row].body //?? ""
        note = notes[indexPath.row].note
            //currentItem = title + "\n" + body
        currentItem = note
        //}

        print("indexPath = \(indexPath)")
        
        performSegue(withIdentifier: "showNote", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation  - This was part of the template for the class
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let noteViewController = segue.destination as? NoteViewController {
            noteViewController.text = currentItem
        }
    }
    
    
    func save() {
        // will want to create a property and store multiple keys in that property,
        // instead of just "notes" (so we can include to-do's reminders, tasks, and projects.)
        //UserDefaults.standard.set(notes, forKey: "notes") //    <- this was the original way we did it which didn't save to a .txt.
        let a = NSArray(array: notes as [Any])
        //let a = NSArray(array: noteData)
        
        do {
            try a.write(to: fileURL)
        } catch {
            print("error writing to file")
        }
    }
    
    
    func load() {
        // if the data is loaded into loaded data, call everything inside the if statement
        //if let loadedData:[String] = UserDefaults.standard.value(forKey: "notes") as? [String] {
        var loadedData: [Note]? = []
        
        //loadedData = NSArray(contentsOf:fileURL) as? [Note]
        
        if NSArray(contentsOf:fileURL) != nil {//as? [Note]? != nil {
        //if loadedData != nil {
            loadedData = NSArray(contentsOf:fileURL) as? [Note]
        
        //  if let loadedData: = NSArray(contentsOf:fileURL) as? [Note] {
            // set data equal to the data from persistent storage
            notes = loadedData!
            // reload the table.
            noteTable.reloadData()
        }
    }
}
