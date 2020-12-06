//
//  TodoListViewController.swift
//  TodoListApp_Part_03
//
//  Created by Raj Kumar Shahu on 2020-11-30.
//  StudentID: 300783746
//  @Desc: This is the third and final part of a three-part Todo List Assignment. This part consists of modification of the User Interface (UI) and logic that was built for the previous version of Todo App to enable gesture controls.
//  Copyright © 2020 Centennial College. All rights reserved.

import UIKit

import CoreData

// TodoTableViewCell class declaration for the cell
class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoListItemLabel: UILabel!
    @IBOutlet weak var todoDateLabel: UILabel!
}

var cellIndex = 0

class TodoListTableViewController: UITableViewController {
 
    // Array of todos
    var todos : [TodoData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // Anytime view is about to appear this function gets called. This is where we access coredata
    override func viewWillAppear(_ animated: Bool) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataToDoData = try? context.fetch(TodoData.fetchRequest()) as? [TodoData] {
                todos = coreDataToDoData
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Making a new table view cell from TodoTableViewCell class
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! TodoTableViewCell
        
        // Pulling out todo from the array according to index and set to todoList
        let todoList =  todos[indexPath.row]
        let today = Date();
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d, yyyy hh:mm a"
        let formattedTodoDate = dateFormatter.date(from: todoList.todoDate ?? "Sunday November 29, 2020 11:59 pm")
        
        cell.todoListItemLabel?.text = todoList.todoItem
        cell.todoDateLabel?.text = todoList.todoDate
        cell.todoDateLabel?.isHidden = false;
        if(todoList.hasDueDate == false) {
            cell.todoDateLabel?.isHidden = true;
        }
        
        let strikeThrough: NSMutableAttributedString =  NSMutableAttributedString(string: cell.todoListItemLabel.text!)
        strikeThrough.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, strikeThrough.length))
        
        let clearStrikeThrough: NSMutableAttributedString =  NSMutableAttributedString(string: cell.todoListItemLabel.text!)
        clearStrikeThrough.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, strikeThrough.length))
        
        cell.todoListItemLabel.textColor = UIColor.black
        cell.todoListItemLabel.attributedText = clearStrikeThrough;
        cell.todoDateLabel?.textColor = UIColor.black;
        
        if (formattedTodoDate! < today){
            cell.todoDateLabel?.text = "Overdue";
            cell.todoListItemLabel?.textColor = UIColor.red;
            cell.todoDateLabel?.textColor = UIColor.red;
        }
        
        if (todoList.isComplete == true) {
            cell.todoListItemLabel.textColor = UIColor.gray
            cell.todoListItemLabel.attributedText = strikeThrough;
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        
        let selectedTodo = todos[indexPath.row]
        
        performSegue(withIdentifier: "TodoDetail", sender: selectedTodo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let todoDetailViewController = segue.destination as? TodoDetailViewController {
            if let toDo = sender as? TodoData {
                todoDetailViewController.todo = toDo
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // declaring custom actions for swiped cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // declaring Delete action when swiped cell
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (contextualAction, view, boolValue) in
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                // removing todo from the list of array (in backend)
                context.delete(self.todos[indexPath.row])
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
            }
            // removing cell from the tableView (in frontend)
            self.todos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        // declaring Complete todo action when swiped cell
        let doneAction = UIContextualAction(style: .normal, title: "Complete") {  (contextualAction, view, boolValue) in

            if ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) != nil{
           
                let selectedTodo = self.todos[indexPath.row]
                
                selectedTodo.isComplete = selectedTodo.isComplete ? false : true

                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
            tableView.reloadData()
        }
        doneAction.backgroundColor = .systemYellow
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        doneAction.image = UIImage(systemName: "checkmark.seal.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let detailAction = UIContextualAction(style: .destructive, title: "Detail") { (action, view, handler) in
            
            let selectedTodo = self.todos[indexPath.row]
            self.performSegue(withIdentifier: "TodoDetail", sender: selectedTodo)
        }
        detailAction.backgroundColor = .systemBlue
        detailAction.image = UIImage(systemName: "eye.fill")
        let configuration = UISwipeActionsConfiguration(actions: [detailAction])
        return configuration
    }
}


