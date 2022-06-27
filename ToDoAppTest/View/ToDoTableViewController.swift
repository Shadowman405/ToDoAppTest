//
//  ToDoTableViewController.swift
//  ToDoAppTest
//
//  Created by Maxim Mitin on 15.06.22.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var item = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadItems()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Lets Add Some Events", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let safeText = textField.text{
                if safeText != "" {
                    let newItem = Item(context: self.context)
                    
                    newItem.title = safeText
                    newItem.done = false
                    newItem.parentCategory = self.selectedCategory
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

extension ToDoTableViewController: UISearchBarDelegate {
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
    
    // MARK: - SearchBar methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    //MARK: -  Core Data func save and load
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with requset: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            requset.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            requset.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        requset.predicate = compoundPredicate
        
        do {
            item = try context.fetch(requset)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}
