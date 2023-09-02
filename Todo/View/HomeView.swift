//
//  ViewController.swift
//  Todo
//
//  Created by Karl Revilla on 1/9/2023.
//

import Foundation
import UIKit

class HomeView: UIViewController {
    let homeViewModel = HomeViewModel()
    
    let containerView = UIView()
    let headerContainer = UIView()
    let headerTitle = UILabel()
    let hideCompleteButton = UIButton()
    let addNewTodoButton = UIButton()
    let todoTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.getTodo()
        
        // MARK: Observers
        NotificationCenter.default.addObserver(self, selector: #selector(handleHideCompleteChange(_:)), name: .hideCompletedChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTodoChanged(_:)), name: .todosChanged, object: nil)
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleHideCompleteChange(_ notification: Notification) {
        if let newValue = notification.object as? Bool {
            let buttonTitle = newValue ? "Show Completed" : "Hide Completed"
            hideCompleteButton.setTitle(buttonTitle, for: .normal)
            todoTableView.reloadData()
        }
    }
    
    @objc func handleTodoChanged(_ notification: Notification) {
//        todoTableView.reloadData()
    }
    
    @objc func onPressAdd() {
        let formController = TodoFormView()
        
        formController.onAddCallback = homeViewModel.onAddNewTodo(newTodo:)

        formController.modalTransitionStyle = .coverVertical
        formController.modalPresentationStyle = .popover

        present(formController, animated: true)
    }
    
    func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        // MARK: Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // MARK: Header
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.backgroundColor = .white
        
        // MARK: Header Title
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.text = "Todo"
        headerTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        // MARK: Hide Complete Button
        hideCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        hideCompleteButton.setTitle("Hide Completed", for: .normal)
        hideCompleteButton.setTitleColor(.link, for: .normal)
        hideCompleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        hideCompleteButton.addTarget(homeViewModel, action: #selector(homeViewModel.onToggleCompleted), for: .touchUpInside)
        
        containerView.addSubview(headerContainer)
        headerContainer.addSubview(headerTitle)
        headerContainer.addSubview(hideCompleteButton)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerContainer.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            headerTitle.topAnchor.constraint(equalTo: headerContainer.safeAreaLayoutGuide.topAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: headerContainer.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            hideCompleteButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            hideCompleteButton.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            hideCompleteButton.bottomAnchor.constraint(equalTo: headerTitle.bottomAnchor),
        ])
        
        
        // MARK: FAB New Button
        let plusButton = UIImage(systemName: "plus")
        addNewTodoButton.translatesAutoresizingMaskIntoConstraints = false
        addNewTodoButton.setImage(plusButton, for: .normal)
        addNewTodoButton.tintColor = .black
        addNewTodoButton.backgroundColor = .white
        addNewTodoButton.layer.borderWidth = 1
        addNewTodoButton.layer.cornerRadius = 25
        addNewTodoButton.layer.cornerCurve = .continuous
        addNewTodoButton.addTarget(self, action: #selector(onPressAdd), for: .touchUpInside)
        
        // MARK: Todo Table View
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.translatesAutoresizingMaskIntoConstraints = false
        todoTableView.register(TodoItemTableCell.self, forCellReuseIdentifier: TodoItemTableCell.identifier)
        
        containerView.addSubview(todoTableView)
        containerView.addSubview(addNewTodoButton)
        
        NSLayoutConstraint.activate([
            addNewTodoButton.heightAnchor.constraint(equalToConstant: 50),
            addNewTodoButton.widthAnchor.constraint(equalTo: addNewTodoButton.heightAnchor),
            addNewTodoButton.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addNewTodoButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            todoTableView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 44),
            todoTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        print("Count \(self.homeViewModel.todos.count)")
        
        return self.homeViewModel.todos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableCell.identifier, for: indexPath) as! TodoItemTableCell
        let todo = self.homeViewModel.todos[indexPath.section]
        
        cell.todoTitleLabel.text = todo.value(forKey: #keyPath(Todo.title)) as? String
        
        if let isSelected = todo.value(forKey: #keyPath(Todo.checked)) as? Bool {
            cell.checkboxButton.isSelected = isSelected
        }
        
        if let date = todo.value(forKey: #keyPath(Todo.date)) as? Date {
            cell.todoDateLabel.text = formatDate(date: date, format: "h:mm a")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = self.homeViewModel.todos[indexPath.section]
        let actionTitle = todo.checked ? "Uncheck" : "Check"
        
        let checkAction = UIContextualAction(style: .normal, title: actionTitle) { (action, view, completionHandler) in
            // Handle the "more" action here
            completionHandler(true)
            self.onCheck(indexPath: indexPath)
        }

        checkAction.backgroundColor = todo.checked ? .blue : .green

        return UISwipeActionsConfiguration(actions: [checkAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            
            
            self.homeViewModel.onDeleteTodo(index: indexPath.section)
            self.todoTableView.reloadData()
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.onCheck(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func onCheck(indexPath: IndexPath) {
        self.homeViewModel.onToggleTodo(index: indexPath.section)

        if self.homeViewModel.hideCompleted {
            self.todoTableView.reloadData()
        } else {
            self.todoTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

