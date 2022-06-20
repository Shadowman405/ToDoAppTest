//
//  ToDoTableViewController.swift
//  ToDoAppTest
//
//  Created by Maxim Mitin on 15.06.22.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var item = ["Kiss Bebra", "Touch Uncle Bogdan", "Watch JoJo", "Make Gachi Remix For Some Song"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Lets Add Some Events", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //somthng happens
            self.item.append(textField.text!) // fix and unwrap text
            self.tableView.reloadData()
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
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(item[indexPath.row])
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.accessoryType == .checkmark ? .none : .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
