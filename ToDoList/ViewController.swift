//
//  ViewController.swift
//  ToDoList
//
//  Created by Pallavi on 2024-10-14.
//

import UIKit

class TodoListViewController: UITableViewController {

    var todoItems: [String] = [] {
        didSet {
            saveItems() // Save items whenever they are updated
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the page
        title = "To-Do List"
        
        // Add an "Add" button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        // Load saved items from UserDefaults
        loadItems()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if !todoItems.isEmpty {
                    cell.textLabel?.text = todoItems[indexPath.row] // Set the text of the cell to the corresponding item
                } else {
                    cell.textLabel?.text = "No items available" // Optional: Display a message if the list is empty
                }
        return cell
    }

    @objc func addItem() {
        let alertController = UIAlertController(title: "New Item", message: "Add a new to-do item", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter item"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty {
                self.todoItems.append(text)
                self.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func saveItems() {
        UserDefaults.standard.set(todoItems, forKey: "todoItems")
    }

    func loadItems() {
        if let savedItems = UserDefaults.standard.array(forKey: "todoItems") as? [String] {
            todoItems = savedItems
        }
    }
}
