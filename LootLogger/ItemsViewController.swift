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
        let view = TableViewHeader(
            frame: CGRect(x: 0, y: 0, width: 0, height: 60)
        )

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.delegate = self
        tableView.tableHeaderView = headerView

        tableView.register(
            ItemCell.self,
            forCellReuseIdentifier: NSStringFromClass(ItemCell.self)
        )
    }
}

// MARK: - UITableViewDataSource

extension ItemsViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return itemStore.allItems.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NSStringFromClass(ItemCell.self),
                for: indexPath
            )
                as? ItemCell
        else { fatalError("Error with ItemCell") }

        let allItems = itemStore.allItems
        let currentItem = allItems[indexPath.row]

        cell.nameLabel.text = currentItem.name
        cell.serialNumberLabel.text = currentItem.serialNumber
        cell.valueLabel.text = "$\(currentItem.valueInDollars)"
        cell.valueLabel.textColor =
            currentItem.valueInDollars >= 50 ? .systemRed : .systemGreen

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]

            itemStore.removeItem(item)

            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        itemStore.moveItem(
            from: sourceIndexPath.row,
            to: destinationIndexPath.row
        )
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

        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)

            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
}
