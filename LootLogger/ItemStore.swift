//
//  ItemStore.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import UIKit

class ItemStore {
    private(set) var allItems = [Item]()
    private let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let documentDirectory = documentsDirectories.first!

        return documentDirectory.appendingPathComponent(
            "items.plist",
            conformingTo: .propertyList
        )
    }()

    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items: \(error)")
        }

        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(saveChanges),
            name: UIScene.didEnterBackgroundNotification,
            object: nil
        )
    }

    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)

        allItems.append(newItem)

        return newItem
    }

    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }

    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }

        let movedItem = allItems[fromIndex]

        allItems.remove(at: fromIndex)

        allItems.insert(movedItem, at: toIndex)
    }

    @objc func saveChanges() throws {
        print("Saving items to: \(itemArchiveURL)")

        let encoder = PropertyListEncoder()
        let data = try encoder.encode(allItems)

        try data.write(to: itemArchiveURL, options: .atomic)

        print("Saved all of the items")
    }
}
