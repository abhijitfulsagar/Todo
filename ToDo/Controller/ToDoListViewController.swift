//
//  ViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 4/6/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit
import  CoreData

class ToDoListViewController: UITableViewController{

    var itemArray=[Item]()
   
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        tableView.reloadData()
        
    }
    
    //MARK: TableView DataSource methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
     //MARK: TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //these two lines will actually delete data from database
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //this line toggle the checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //the above statement means below if condition
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add item 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var varText = UITextField()
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newItem=Item(context: self.context)
            newItem.title=varText.text!
            newItem.done=false
            
            self.itemArray.append(newItem)
            self.saveData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="enter a todo item"
            varText=alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manipulation methods
    func saveData(){
        
        do {
            try context.save()
        } catch {
            print("Error saving in data:\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item>=Item.fetchRequest()){
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error in Fetching: \(error)")
        }
          tableView.reloadData()
    }
    
    
   
}

//MARK: SEARCH BAR METHODS
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request :NSFetchRequest<Item>=Item.fetchRequest()
        
        //check NSPredicate on google.
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      
       loadItems(with: request)
      
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //this will select the main thread
            DispatchQueue.main.async {
                 //this tells that searchbar should not be the currently selected and the cursor in the search bar goes away
                searchBar.resignFirstResponder()
            }
           
            
        }
    }
}

