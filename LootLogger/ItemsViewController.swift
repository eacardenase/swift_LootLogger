//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    var headerView: TableViewHeader = {
        let view = TableViewHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
}

// MARK: - UITableViewDataSource

extension ItemsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemStore.allItems.count { $0.valueInDollars <= 50 }
        }
        
        return itemStore.allItems.count { $0.valueInDollars > 50 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        
        let items: [Item]
        
        
        if section == 0 {
            items = itemStore.allItems.filter({ $0.valueInDollars <= 50 })
        } else {
            items = itemStore.allItems.filter({ $0.valueInDollars > 50 })
        }
        
        let currentItem = items[indexPath.row]
        
        var content = UIListContentConfiguration.valueCell()
        content.text = currentItem.name
        content.secondaryText = "$\(currentItem.valueInDollars)"
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            itemStore.removeItem(item)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "<= $50"
        }
        
        return "> $50"
    }
}

// MARK: - UITableViewDelegate

extension ItemsViewController {
}

// MARK: - TableViewHeaderDelegate

extension ItemsViewController: TableViewHeaderDelegate {

    func toggleEditingMode(_ sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            
            setEditing(true, animated: true)
        }
    }
    
    func addNewItem(_ sender: UIButton) {
        let newItem = itemStore.createItem()
        let isItemValueLessThanOrEqualTo50 = newItem.valueInDollars <= 50
        let sectionIndex = newItem.valueInDollars <= 50 ? 0 : 1
        
        let items: [Item]
        
        if isItemValueLessThanOrEqualTo50 {
            items = itemStore.allItems.filter({ $0.valueInDollars <= 50 })
        } else {
            items = itemStore.allItems.filter({ $0.valueInDollars > 50 })
        }
        
        if let index = items.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: sectionIndex)

            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
}
