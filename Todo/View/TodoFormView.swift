//
//  TodoFormView.swift
//  Todo
//
//  Created by Karl Revilla on 1/9/2023.
//

import UIKit

class TodoFormView: UIViewController {
    
    let timeFormViewModel = TimeFormViewModel()
    var onAddCallback: ((_: Todo) -> Void)?
    
    let containerView = UIView()
    let pageTitle = UILabel()
    let nameFormRow = UIView()
    let nameFormLabel = UILabel()
    let nameFormInput = UITextField()
    let hourFormLabel = UILabel()
    let hourFormPicker = UIDatePicker()
    let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        // MARK: Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
        ])
        
        // MARK: Page Title
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.text = "Add a task"
        pageTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        containerView.addSubview(pageTitle)
        
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            pageTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pageTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        // MARK: Name Label and Input
        nameFormLabel.translatesAutoresizingMaskIntoConstraints = false
        nameFormLabel.text = "Name"
        nameFormLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        nameFormInput.translatesAutoresizingMaskIntoConstraints = false
        nameFormInput.borderStyle = .roundedRect
        nameFormInput.placeholder = "Enter task name"
        nameFormInput.addTarget(timeFormViewModel, action: #selector(timeFormViewModel.onChangeFormName(_:)), for: .editingChanged)
        
        containerView.addSubview(nameFormLabel)
        containerView.addSubview(nameFormInput)
        
        NSLayoutConstraint.activate([
            nameFormLabel.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 32),
            nameFormLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameFormLabel.widthAnchor.constraint(equalToConstant: 80),
            
            nameFormInput.leadingAnchor.constraint(equalTo: nameFormLabel.trailingAnchor, constant: 8),
            nameFormInput.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            nameFormInput.centerYAnchor.constraint(equalTo: nameFormLabel.centerYAnchor),
        ])
        
        // MARK: Hour Label and Input
        hourFormLabel.translatesAutoresizingMaskIntoConstraints = false
        hourFormLabel.text = "Hour"
        hourFormLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        hourFormPicker.translatesAutoresizingMaskIntoConstraints = false
        hourFormPicker.datePickerMode = .time
        hourFormPicker.date = Date()
        hourFormPicker.addTarget(timeFormViewModel, action: #selector(timeFormViewModel.onChangeFormDate(_:)), for: .valueChanged)
        
        containerView.addSubview(hourFormLabel)
        containerView.addSubview(hourFormPicker)
        
        NSLayoutConstraint.activate([
            hourFormLabel.topAnchor.constraint(equalTo: nameFormLabel.bottomAnchor, constant: 32),
            hourFormLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hourFormLabel.widthAnchor.constraint(equalToConstant: 80),
            
            hourFormPicker.leadingAnchor.constraint(equalTo: hourFormLabel.trailingAnchor, constant: 8),
            hourFormPicker.centerYAnchor.constraint(equalTo: hourFormLabel.centerYAnchor),
        ])
        
        // MARK: Done Button
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.backgroundColor = .black
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        doneButton.layer.cornerRadius = 10
        doneButton.layer.cornerCurve = .continuous
        doneButton.addTarget(self, action: #selector(self.onPressDone), for: .touchUpInside)
        containerView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: hourFormLabel.bottomAnchor, constant: 32),
            doneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func onPressDone() {
        guard let inputText = nameFormInput.text, inputText != "" else {
            print("Invalid")
            return
        }
        
        guard let onAddCallback = onAddCallback else {
            print("Please set onAddCallback")
            return
        }
        
        let newTodo = self.timeFormViewModel.save()
        onAddCallback(newTodo)
        self.dismiss(animated: true)
    }
}
