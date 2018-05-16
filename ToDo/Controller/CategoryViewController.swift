//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 5/13/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = UIColor(hexString : categories?[indexPath.row].color ?? "1D9BF6")
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
    
    //MARK: delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let itemDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemDeletion)
                }
            }catch{
                 print("ERROR in deleting:\(error)")
            }
        }
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
        let addAction=UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategoryItem = Category()
            newCategoryItem.name = textField.text!
            newCategoryItem.color = UIColor.randomFlat.hexValue()
            self.saveCategories(category: newCategoryItem)
        }
        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter the category"
            textField = alertTextField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}


