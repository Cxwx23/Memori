//
//  ListTableViewController.swift
//  Memori
//
//  Created by Cole Warner on 11/9/20.
//

import UIKit

class ListTableViewController: UITableViewController {
    //  Connects this table view controller to the table view for notes in the storyboard
    @IBOutlet var listTable: UITableView!
    
    
    var lists: [String] = []
    var listData: [List] = []
    var checklist: [String] = [""]
    
    var selectedRow = -1
    var newRowText: String = ""
    
    var listFileURL: URL!
    
    var currentItem: String = ""
    var currentItemChecklist: [String] = [""]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  sets the datasource for the listTable object -
        listTable.dataSource = self
        listTable.delegate = self
        self.title = "Lists"
        
        //  creates the behavior of the button that will be used to add notes to the list on the table
        let addListButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList))
        //  creates the actual add list button in the upper right corner
        self.navigationItem.rightBarButtonItem = addListButton
        //  creates an edit button on the upper left hand corner
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        
        // accesses the document directory
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        // accesses the notes.txt file.
        listFileURL = baseURL.appendingPathComponent("SavedListArray.txt")    // used to be "notes.txt"
        
        // load data from persistent storage
        load()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("index = \(selectedRow)")
        
        //  This was a workaround which prevents an error when the ListTableView is about to appear, coming from NoteTableView
        //  when the user has just deleted a note with an index outside the range for the ListTable
        if selectedRow >= listData.count {
            selectedRow = 0;
            print("index = \(selectedRow)")
        }
         
        if selectedRow == -1 || listData.count == 0 {
            return
        }
        
        listData[selectedRow].title = newRowText
        
        if newRowText == "" {
            //data.remove(at: selectedRow)
            listData.remove(at: selectedRow)
        }
        
        listTable.reloadData()
        
        save()  // looks like this may not need to be called unless its for persistence
    }
    
    
    @objc func addList() {
        //  Eliminates the ability to add rows while the table is in editing mode
        if listTable.isEditing {
            return
        }
        
        //  creates a new list with the entered title and an empty list (for now)
        //let list: List = List(title: "", checklist: [""], checklistItems: [ListItem])
        //let list: List = List(title: "", checklist: [""])
        
        let list: List = List(title: "", checklist: [])
        
        //  inserts the list into the lists array
        listData.insert(list, at: 0)
        
        //  sets the value of index path to row 0 and section 0 - basically just adding the new list to the top of the table view
        let indexPath: IndexPath = IndexPath(row: 0, section: 0)
        
        //  Adds the new row
        listTable.insertRows(at: [indexPath], with: .automatic)
        listTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        // go into detail view of note
        self.performSegue(withIdentifier: "showList", sender: nil)
        
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return listData.count
    }

    // this function iterates through the array to populate the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  indexPath is sort of like an iterator in C++ and returns an array of two ints representing the row and section of a given table cell
        let listCell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)

        //  sets the text in my textLabel storyboard object to the value in the lists[].title string at indexPath.row
        listCell.textLabel?.text = listData[indexPath.row].title

        return listCell
    }
    
    
    // This function runs when the edit button is pressed
    override func setEditing(_ editing: Bool, animated: Bool) {
        //  You always have to call the constructore of the superclass in iOS
        super.setEditing(editing, animated: animated)
        //  calls the set editing class of the table object
        listTable.setEditing(editing, animated: animated)
        
        save()
    }
    
    //  removes a row when the delete button is pressed while in editing mode (after pressing the edit button
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //  removes the data from the lists array
        listData.remove(at: indexPath.row)
        
        //  removes the row from the table view
        listTable.deleteRows(at: [indexPath], with: .fade)

    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //  currentItem = data[indexPath.row]
        //currentItem = lists[indexPath.row].title + "\n"
        //currentItem = listData[indexPath.row].title
        //currentItemChecklist = listData[indexPath.row].checklist
           
        //print("indexPath = \(indexPath)")
        //  currentItem = notes[indexPath.row]
        performSegue(withIdentifier: "showList", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*if let listViewController = segue.destination as? ListViewController
        {
            listViewController.listTitle = currentItem
            listViewController.checklist = currentItemChecklist
        }*/
        
        
        let listViewController = segue.destination as! ListViewController
        
        selectedRow = listTable.indexPathForSelectedRow!.row
        
        listViewController.masterView = self
        
        listViewController.setListTitle(t: listData[selectedRow].title)
    }
    
    
    
    // MARK: - Data Persistence
    
    func save() {
        
        var listTitlesToSave: [String] = [""]
        
        
        for lists in listData {
            listTitlesToSave.append(lists.title)
        }
        
        let a = NSArray(array: listTitlesToSave as [Any])
        
        do {
            try a.write(to: listFileURL)
            print("saved list data")
        } catch {
            print("error writing to file")
        }
        
        /*for lists in listData {
            for items in listData[lists] {
                
            }
        }*/
        var listItems: [[[Any]]] = [[[Any]]]()
        
        /*for list in listData {
            for item in 0...3 {
                for bool in 0...1 {
                    listItems.append([listData[list].title, listData[list].checklist[item], listData[list].checklist[checked])
            }
        }*/
            
        
        print(listItems)

        //print(listData)
        
        //let fileUrl = NSURL(fileURLWithPath: "/tmp/foo.plist") // Your path here
        //let listOfTasks = [["Hi", "Hello", "12:00"], ["Hey there", "What's up?", "3:17"]]

        // Save to file
        //(listOfTasks as NSArray).write(to: fileUrl as URL, atomically: true)

        // Read from file
        //let savedArray = NSArray(contentsOf: fileUrl as URL) as! [[String]]

        //print(savedArray)
        
        
    }
    
    
    func load() {
        
        //  if let loadedData: [String] = NSArray(contentsOf: noteFileURL) as? [String] {
        if let loadedData: [String] = NSArray(contentsOf: listFileURL) as? [String] {
            print("loaded list data")
            
            
            for index in loadedData {
                let loadedListTitle: List = List(title: index, checklist: [])
                listData.append(loadedListTitle)
            }
            
            listTable.reloadData()
        }
        
    }
    
 
 
 
    // MARK: - Functions that were included in the template but are not yet being used
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

}
