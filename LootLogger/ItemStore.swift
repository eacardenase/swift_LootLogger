//
//  ItemStore.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import Foundation

class ItemStore {
    private(set) var allItems = [Item]()
    
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
}
