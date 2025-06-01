//
//  ItemStore.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import Foundation

class ItemStore {
    private(set) var allItems = [Item]()

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
}
