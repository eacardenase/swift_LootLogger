//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    var headerView: TableViewHeaderView = {
        let view = TableViewHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = headerView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
}

// MARK: - UITableViewDataSource

extension ItemsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        
        let allItems = itemStore.allItems
        let currentItem = allItems[indexPath.row]
        
        var content = UIListContentConfiguration.valueCell()
        content.text = currentItem.name
        content.secondaryText = "$\(currentItem.valueInDollars)"
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ItemsViewController {
}
