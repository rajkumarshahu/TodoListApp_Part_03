//
//  AddTodoViewController.swift
//  TodoListApp_Part_03
//
//  Created by Raj Kumar Shahu on 2020-11-30.
//  StudentID: 300783746
//  @Desc: This is the third and final part of a three-part Todo List Assignment. This part consists of modification of the User Interface (UI) and logic that was built for the previous version of Todo App to enable gesture controls.
//  Copyright © 2020 Centennial College. All rights reserved.

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var todoNameTextField: UITextField!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addTodoTapped(_ sender: Any) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            let today = Date()
            var dateComponent = DateComponents()
            dateComponent.day = 1
            let dueDate = Calendar.current.date(byAdding: dateComponent, to: today)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE MMMM d, yyyy hh:mm a"
            
            // New todo object
            let todo = TodoData(context: context)
            
            // Creating todo item with todo name and date
            if let todoItem =  todoNameTextField.text {
                // Specify todo name and date
                todo.todoItem = todoItem
                todo.todoDate = formatter.string(from: dueDate!)
                todo.detail = detailTextView.text
                
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                // Pop back to list screen
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
