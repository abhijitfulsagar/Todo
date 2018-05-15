//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 5/13/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    var categories : Results<Category>?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    //MARK: TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if not nill then return categories count or else 1
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    //MARK: Data manipulation methods
    
    func saveCategories(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        //this reads all the data from the realm database
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    //MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action=UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategoryItem = Category()
            newCategoryItem.name = textField.text!
            self.saveCategories(category: newCategoryItem)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter the category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
}
