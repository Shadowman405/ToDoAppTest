//
//  ToDoTableViewController.swift
//  ToDoAppTest
//
//  Created by Maxim Mitin on 15.06.22.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var item = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Bebra"
        item.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Find Bogdan"
        item.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Find Pipa"
        item.append(newItem3)
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            item = items
//        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Lets Add Some Events", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //somthng happens
            if let safeText = textField.text{
                if safeText != "" {
                    let newItem = Item()
                    newItem.title = safeText
                    
                    self.item.append(newItem)
                    self.defaults.set(self.item, forKey: "TodoListArray")
                    self.tableView.reloadData()
                } else {
                    let alertTF = UIAlertController(title: "Empty string !!!", message: "Type something in textfield", preferredStyle: .alert)
                    self.present(alertTF, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        alertTF.dismiss(animated: true)
                    }
                }
            }
        }
        
        alert.addTextField { alertTF in
            alertTF.placeholder = " Type something "
            textField = alertTF
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }

}

// MARK: - Table view data source

extension ToDoTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item[indexPath.row].title
        
        if item[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item[indexPath.row].done = !item[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
