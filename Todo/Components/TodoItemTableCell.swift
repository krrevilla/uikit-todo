//
//  TodoItemTableCell.swift
//  Todo
//
//  Created by Karl Revilla on 1/9/2023.
//

import UIKit

class TodoItemTableCell: UITableViewCell {
    static let identifier = "TodoItemTableCell"
    
    let containerView = UIView()
    let checkboxButton = UIButton()
    let todoTitleLabel = UILabel()
    let todoDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupUI() {
        // MARK: Container View
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
        
        // MARK: Checkbox Button
        let unselectedImage = UIImage(systemName: "square")
        let selectedImage = UIImage(systemName: "checkmark.square.fill")

        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.setImage(unselectedImage, for: .normal)
        checkboxButton.setImage(selectedImage, for: .selected)
        checkboxButton.tintColor = .black
        containerView.addSubview(checkboxButton)
        
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            checkboxButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 25),
            checkboxButton.heightAnchor.constraint(equalTo: checkboxButton.widthAnchor)
        ])
        
        // MARK: Label
        todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        todoTitleLabel.numberOfLines = 0
        todoTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        //  MARK: Date
        todoDateLabel.translatesAutoresizingMaskIntoConstraints = false
        todoDateLabel.numberOfLines = 1
        todoDateLabel.font = UIFont.systemFont(ofSize: 12)
        todoDateLabel.textColor = .secondaryLabel
        
        containerView.addSubview(todoTitleLabel)
        containerView.addSubview(todoDateLabel)
        
        NSLayoutConstraint.activate([
            todoTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            todoTitleLabel.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            todoTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            todoDateLabel.topAnchor.constraint(equalTo: todoTitleLabel.bottomAnchor, constant: 4),
            todoDateLabel.leadingAnchor.constraint(equalTo: todoTitleLabel.leadingAnchor),
            todoDateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
