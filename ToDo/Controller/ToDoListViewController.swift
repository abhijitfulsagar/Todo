//
//  ViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 4/6/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray=[Item]()
    let defaults=UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem=Item()
        newItem.title="Shopping"
        newItem.done=false
        let newItem1=Item()
        newItem1.title="Travelling"
        newItem1.done=false
        let newItem2=Item()
        newItem2.title="Swimming"
        newItem2.done=false
        itemArray.append(newItem)
        itemArray.append(newItem1)
        itemArray.append(newItem2)
        
        if let items=defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        //the above statement means below if condition
//        if itemArray[indexPath.row].done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //the above statement means below if condition
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK -Add item 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var varText = UITextField()
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem=Item()
            newItem.title=varText.text!
            newItem.done=false
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray ")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="enter a todo item"
            varText=alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

