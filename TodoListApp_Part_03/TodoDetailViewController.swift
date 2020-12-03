//
//  TodoDetailViewController.swift
//  TodoListApp_Part_03
//
//  Created by Raj Kumar Shahu on 2020-11-30.
//  StudentID: 300783746
//  @Desc: This is the third and final part of a three-part Todo List Assignment. This part consists of modification of the User Interface (UI) and logic that was built for the previous version of Todo App to enable gesture controls.
//  Copyright © 2020 Centennial College. All rights reserved.

import UIKit

import CoreData

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var todoTitleLabel: UILabel!
    
    @IBOutlet weak var todoNameTextView: UITextField!
    
    @IBOutlet weak var todoDetailTextView: UITextView!
    
    @IBOutlet weak var hasDueDateSwitch: UISwitch!
    
    @IBOutlet weak var isCompleteSwitch: UISwitch!
    
    @IBOutlet weak var todoDatePicker: UIDatePicker!
    
    // todo of type TodoData
    var todo : TodoData? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dueDate = todo?.todoDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM d, yyyy hh:mm a"
        
        let todoDate = dateFormatter.date(from: dueDate!)
        
        if todo != nil {
            if let todoItem = todo?.todoItem{
                todoTitleLabel?.text = todoItem + "'s Detail"
            }
            
            todoNameTextView?.text = todo!.todoItem
            todoDetailTextView?.text = todo!.detail
            
            self.todoDatePicker.isUserInteractionEnabled = false
            self.todoDatePicker.date = todoDate!
            self.hasDueDateSwitch.isOn = false
            if(self.todo!.hasDueDate == true) {
                self.todoDatePicker.isUserInteractionEnabled = true
                self.hasDueDateSwitch.isOn = true
            }
            isCompleteSwitch.isOn = todo?.isComplete ?? false
        }
    }
    
    
    @IBAction func isCompleteSwitchChanged(_ sender: Any) {
        
        if ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) != nil{
            if self.todo != nil {
                
                self.todo?.isComplete = true;             
                
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            }
        }
    }
    
    // Enable or disable datepicker based on switch state
    @IBAction func hasDueDateSwitchChanged(_ sender: Any) {
        
        if(hasDueDateSwitch.isOn){
            self.todoDatePicker.isUserInteractionEnabled = true
        }
        else {
            self.todoDatePicker.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func trashButtonTapped(_ sender: UIButton) {
        
        let deleteAlert = UIAlertController(title: "Delete", message: "Do you really want to delete this?.", preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                if self.todo != nil {
                    context.delete(self.todo!)
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        let clearAlert = UIAlertController(title: "Discard changes?", message: "Do you really want to discard the changes?.", preferredStyle: UIAlertController.Style.alert)
        
        clearAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        clearAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("No Tapped")
        }))
        present(clearAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        
        let updateAlert = UIAlertController(title: "Update", message: "Do you really want to update this?.", preferredStyle: UIAlertController.Style.alert)
        
        updateAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction!) in
            
            if ((UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext) != nil{
                let todoDate = self.todoDatePicker.date
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE MMMM d, yyyy hh:mm a"
                let formattedTodoDate = dateFormatter.string(from: todoDate)
                
                if self.todo != nil {
                    
                    self.todo?.todoItem = self.todoNameTextView.text
                    
                    self.todo?.detail = self.todoDetailTextView.text
                    
                    self.todo?.todoDate = formattedTodoDate
                    
                    self.todo?.hasDueDate = self.hasDueDateSwitch.isOn ? true : false
                    
                    self.todo?.isComplete = (self.isCompleteSwitch.isOn) ? true: false
                    
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        
        updateAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Cancelled")
        }))
        
        present(updateAlert, animated: true, completion: nil)
    }
}
