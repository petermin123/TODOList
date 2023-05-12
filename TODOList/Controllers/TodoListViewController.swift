//
//  ViewController.swift
//  TODOList
//
//  Created by Honggang Min on 5/06/23.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // UserDefaults are good for storing small bites of data (pun intended)
    // let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Find Levi"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Find Jack"
//        itemArray.append(newItem3)
        
        loadItems()
        // Do any additional setup after loading the view.
    }

    // TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
        
        // Flashes grey briefly, and then becomes white again. Good for UI
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Has the largest scope
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new TODO item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            // What happens when user clicks the 'Add item' button?
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField(configurationHandler: { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            }
        )
                           
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // Save model method
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
    }
    
}

