//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import UIKit

class ItemsViewController: UITableViewController {

    var itemStore: ItemStore
    var imageStore: ImageStore

    var headerView: TableViewHeader = {
        let view = TableViewHeader(
            frame: CGRect(x: 0, y: 0, width: 0, height: 60)
        )

        return view
    }()

    // MARK: - Initializers

    init(itemStore: ItemStore, imageStore: ImageStore) {
        self.itemStore = itemStore
        self.imageStore = imageStore

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "LootLoger"

        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.backButtonTitle = "Back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewItem)
        )

        tableView.backgroundColor = UIColor(named: "Primary Brand Fill Color")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        tableView.register(
            ItemCell.self,
            forCellReuseIdentifier: NSStringFromClass(ItemCell.self)
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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

            imageStore.deleteImage(forKey: item.itemKey)

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

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let currentItem = itemStore.allItems[indexPath.row]
        let detailViewController = DetailViewController(
            for: currentItem,
            with: imageStore
        )

        navigationController?.pushViewController(
            detailViewController,
            animated: true
        )
    }
}

// MARK: - Actions

extension ItemsViewController {

    @objc func addNewItem(_ sender: UIBarButtonItem) {
        let newItem = itemStore.createItem()

        if let index = itemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)

            tableView.insertRows(at: [indexPath], with: .fade)
        }
    }
}
