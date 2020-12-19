//
//  TableViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/7/20.
//

import UIKit

class TableViewController: UITableViewController {
    //  Connects this table view controller to the table view for notes in the storyboard
    @IBOutlet var noteTable: UITableView!
    
    var notes: [String] = []
    var noteData: [Note] = []

    var selectedRow = -1
    var newRowText: String = ""
    
    var noteFileURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // accesses the SavedNoteArray.txt file.
        noteFileURL = baseURL.appendingPathComponent("SavedNoteArray.txt")    // used to be "notes.txt"
        
        // load data from persistent storage
        load()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        print("index = \(selectedRow)")
        
        //  This was a workaround which prevents an error when the NoteTableView is about to appear, coming from ListTableView
        //  when the user has just deleted a note with an index outside the range for the NoteTable
        if selectedRow >= noteData.count {
            selectedRow = 0;
            print("index = \(selectedRow)")
        }
        
        if selectedRow == -1 || noteData.count == 0 {
            return
        }
        
        
        //data[selectedRow] = newRowText
        noteData[selectedRow].note = newRowText
        
        if newRowText == "" {
            //data.remove(at: selectedRow)
            noteData.remove(at: selectedRow)
        }
        
        noteTable.reloadData()
        
        save()  // looks like this may not need to be called unless its for persistence
    }
    
    
    @objc func addNote() {
        //  Eliminates the ability to add rows while the table is in editing mode
        if noteTable.isEditing {
            return
        }
        
        //  creates a new note with the entered title and an empty note (for now)
        let note: Note = Note(note: "")
        
        //  inserts the note into the notes array
        noteData.insert(note, at: 0)
        
        //  sets the value of index path to row 0 and section 0 - basically just adding the new note to the top of the table view
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        
        //  Adds the new row
        noteTable.insertRows(at: [indexPath], with: .automatic)
        noteTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        // go into detail view of note
        self.performSegue(withIdentifier: "showNote", sender: nil)
        
    }

    // MARK: - Table view data source

    //   This is set to 1 because we are only creating one section with multiple rows
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //  Returns the number of rows in the array holding the objects for the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return notes.count
        return noteData.count
    }
    

    // this function iterates through the array to populate the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  indexPath is sort of like an iterator in C++ and returns an array of two ints representing the row and section of a given table cell
        let noteCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "noteCell")!
        
        //  sets the text in my textLabel storyboard object to the value in the notes[].note string at indexPath.row
        noteCell.textLabel?.text = noteData[indexPath.row].note
        
        //  returns the cell at the current index
        return noteCell
        
    }
    
    // This function runs when the edit button is pressed
    override func setEditing(_ editing: Bool, animated: Bool) {
        //  You always have to call the constructore of the superclass in iOS
        super.setEditing(editing, animated: animated)
        //  calls the set editing class of the table object
        noteTable.setEditing(editing, animated: animated)
        
        save()
    }
    
    //  removes a row when the delete button is pressed while in editing mode (after pressing the edit button
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //  removes the data from the notes array
        noteData.remove(at: indexPath.row)
        
        //  removes the row from the table view
        noteTable.deleteRows(at: [indexPath], with: .fade)

    }

    
    // MARK: - Navigation
    
    //  Gets the selected row from the variable 'indexPath', which is an array with 2 values (number of rows and number of sections
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNote", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation  - This was part of the template for the class
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let noteViewController = segue.destination as! NoteViewController
        
        selectedRow = noteTable.indexPathForSelectedRow!.row
        
        noteViewController.masterView = self
        
        noteViewController.setText(t: noteData[selectedRow].note)
    }
    
    // MARK: - Data Persistence
    
    func save() {
        
        var notesToSave: [String] = []
        
        for n in noteData {
            notesToSave.append(n.note)
        }
        
        let a = NSArray(array: notesToSave as [Any])
        
        do {
            try a.write(to: noteFileURL)
            print("saved note data")
        } catch {
            print("error writing to file")
        }
        
    }
    
    
    func load() {
        
        //  if let loadedData: [String] = NSArray(contentsOf: noteFileURL) as? [String] {
        if let loadedData: [String] = NSArray(contentsOf: noteFileURL) as? [String] {
            print("loaded note data")
            
            
            for index in loadedData {
                let loadedNote: Note = Note(note: index)
                noteData.append(loadedNote)
            }
            
            noteTable.reloadData()
        }
        
    }
    
    // MARK: Functions that were included in the template but are not yet being used
    
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
}
