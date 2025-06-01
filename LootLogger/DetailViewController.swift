//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/31/25.
//

import UIKit

class DetailViewController: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Name"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    let nameField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        
        return textField
    }()
    
    let serialLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Serial"
        
        return label
    }()
    let serialNumberField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        
        return textField
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Value"
        
        return label
    }()
    let valueField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.setContentCompressionResistancePriority(UILayoutPriority(749), for: .horizontal)
        
        return textField
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Date Created"
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = .systemBackground
        
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameField])
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8
        
        let serialStackView = UIStackView(arrangedSubviews: [serialLabel, serialNumberField])
        serialStackView.translatesAutoresizingMaskIntoConstraints = false
        serialStackView.axis = .horizontal
        serialStackView.spacing = 8
        
        let valueStackView = UIStackView(arrangedSubviews: [valueLabel, valueField])
        valueStackView.translatesAutoresizingMaskIntoConstraints = false
        valueStackView.axis = .horizontal
        valueStackView.spacing = 8
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            nameStackView,
            serialStackView,
            valueStackView,
            dateLabel
        ])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            nameField.leadingAnchor.constraint(equalTo: serialNumberField.leadingAnchor),
            serialNumberField.leadingAnchor.constraint(equalTo: valueField.leadingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
