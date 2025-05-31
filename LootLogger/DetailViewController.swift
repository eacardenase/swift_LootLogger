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
        
        return label
    }()
    let nameField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    let serialLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Serial"
        
        return label
    }()
    let serialNumberField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Value"
        
        return label
    }()
    let valueField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Date Created"
        
        return label
    }()
    
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            serialLabel,
            valueLabel,
            dateLabel
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
