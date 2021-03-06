//
//  CategoryTableViewController.swift
//  ToDoAppTest
//
//  Created by Maxim Mitin on 27.06.22.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Items", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destanationVC = segue.destination as! ToDoTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destanationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
// MARK: - IBActions and func
    
    @IBAction func addButtonCLicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { alertTF in
            alertTF.placeholder = " Type something "
            textField = alertTF
        }
        
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
           categories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
}
