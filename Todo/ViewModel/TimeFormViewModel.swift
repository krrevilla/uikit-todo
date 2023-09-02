//
//  TimeFormViewModel.swift
//  Todo
//
//  Created by Karl Revilla on 1/9/2023.
//

import UIKit
import Foundation

extension Notification.Name {
    static let formNameChanged = Notification.Name("formNameChanged")
    static let formDateChanged = Notification.Name("formDateChanged")
}

class TimeFormViewModel {
    var formName = "" {
        didSet {
            NotificationCenter.default.post(name: .formNameChanged, object: self.formName)
        }
    }
    
    var formDate: Date = Date() {
        didSet {
            NotificationCenter.default.post(name: .formDateChanged, object: self.formDate)
        }
    }
    
    @objc func onChangeFormName(_ textField: UITextField) {
        if let updatedText = textField.text {
            formName = updatedText
        }
    }
    
    @objc func onChangeFormDate(_ datePicker: UIDatePicker) {
        formDate = datePicker.date
    }
    
    func save() -> Todo {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newTodo = Todo(context: managedContext)

        newTodo.setValue(formDate, forKey: #keyPath(Todo.date))
        newTodo.setValue(formName, forKey: #keyPath(Todo.title))
        newTodo.setValue(false, forKey: #keyPath(Todo.checked))

        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()

        return newTodo
    }
}
