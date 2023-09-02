//
//  ViewViewModel.swift
//  Todo
//
//  Created by Karl Revilla on 1/9/2023.
//

import CoreData
import Foundation

extension Notification.Name {
    static let hideCompletedChange = Notification.Name("hideCompletedChange")
    static let todosChanged = Notification.Name("todosChanged")
}

class HomeViewModel {
    var hideCompleted = false {
        didSet {
            NotificationCenter.default.post(name: .hideCompletedChange, object: self.hideCompleted)
        }
    }
    
    var data: [Todo] = [] {
        didSet {
            NotificationCenter.default.post(name: .todosChanged, object: self.todos)
        }
    }
        
    var todos: [Todo] {
        if hideCompleted {
            return data.filter { !$0.checked }
        } else {
            return data
        }
    }
    
    func getTodo() {
        let todoFetch: NSFetchRequest<Todo> = Todo.fetchRequest()

        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(todoFetch)

            data = results
        } catch {
            print("Fetch Error")
        }
    }

    @objc func onToggleCompleted() {
        hideCompleted.toggle()
    }
    
    func getDataIndex(index: Int) -> Int? {
        let todo = self.todos[index]
        let dataIndex = self.data.firstIndex  { $0 === todo }
        
        return dataIndex
    }
    
    func onToggleTodo(index: Int) {
        let dataIndex = getDataIndex(index: index)
        
        guard let dataIndex = dataIndex else {
            print("Todo not found")
            return
        }
        self.data[dataIndex].checked.toggle()
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    
    func onAddNewTodo(newTodo: Todo) {
        data.append(newTodo)
    }
    
    func onDeleteTodo(index: Int) {
        let dataIndex = getDataIndex(index: index)
        
        guard let dataIndex = dataIndex else {
            print("Todo not found")
            return
        }
        
        AppDelegate.sharedAppDelegate.coreDataStack.managedContext.delete(self.data[dataIndex])
        self.data.remove(at: index)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
}
