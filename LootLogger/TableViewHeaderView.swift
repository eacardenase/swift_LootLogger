//
//  TableViewHeaderView.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/28/25.
//

import UIKit

class TableViewHeaderView: UIView {
    
    var editButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Edit", for: .normal)
        
        return button
    }()
    
    var addItemButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Add", for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        
        let stackView = UIStackView(arrangedSubviews: [editButton,
                                                       addItemButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
}
