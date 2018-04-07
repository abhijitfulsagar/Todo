//
//  ViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 4/6/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray=["Shopping","Travelling","Studies"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print( itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK -Add item 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var varText = UITextField()
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(varText.text!)
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

