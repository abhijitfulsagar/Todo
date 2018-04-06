//
//  ViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 4/6/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray=["Shopping","Travelling","Studies"]
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
}

