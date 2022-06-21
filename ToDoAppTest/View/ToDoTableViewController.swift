//
//  ToDoTableViewController.swift
//  ToDoAppTest
//
//  Created by Maxim Mitin on 15.06.22.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var item = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
                    self.saveItems()
                    
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
        let rowItem = item[indexPath.row]
        cell.textLabel?.text = item[indexPath.row].title
        
        cell.accessoryType = rowItem.done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item[indexPath.row].done = !item[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // NSCoder func save and load
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(item)
            try data.write(to: dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                item = try decoder.decode([Item].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
