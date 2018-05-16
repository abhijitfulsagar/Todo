//
//  ViewController.swift
//  ToDo
//
//  Created by Abhijit Fulsagar on 4/6/18.
//  Copyright © 2018 Abhijit Fulsagar. All rights reserved.
//

import UIKit
import  RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{

    @IBOutlet weak var todoSearchBar: UISearchBar!
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //        print( FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color{
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exists")}
            if let navBarColor = UIColor(hexString:colorHex){
                navBar.barTintColor = navBarColor
                navBar.largeTitleTextAttributes=[NSAttributedStringKey.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                todoSearchBar.barTintColor = UIColor(hexString: colorHex)
            }
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:FlatWhite()]
    }
    //MARK: TableView DataSource methods
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: (selectedCategory?.color)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
     //MARK: TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    //this will toggle the done property
                    item.done = !item.done
                    //this will delete the item form database
                    //realm.delete(item)
                }
            }catch{
                print("Error occured:\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Add item 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var varText = UITextField()
        let alert = UIAlertController(title: "Add a Todo", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title=varText.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error in saving:\(error)")
                    }
                }
            }
         let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        self.tableView.reloadData()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="enter a todo item"
            varText=alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manipulation methods
    
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
          tableView.reloadData()
    }

    //MARK: delete
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error in deleting:\(error)")
            }
        }
    }
   
}

//MARK: SEARCH BAR METHODS
extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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


