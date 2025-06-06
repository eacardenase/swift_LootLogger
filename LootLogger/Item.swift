//
//  Item.swift
//  LootLogger
//
//  Created by Edwin Cardenas on 5/26/25.
//

import Foundation

class Item: Equatable, Codable {

    enum Category {
        case electronics, clothing, book, other
    }

    enum CodingKeys: String, CodingKey {
        case name
        case valueInDollars
        case serialNumber
        case dateCreated
        case category
    }

    var name: String
    var valueInDollars: Int
    var serialNumber: String
    let dateCreated: Date
    var categoty = Category.other

    init(name: String, serialNumber: String, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
    }

    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]

            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!

            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber = UUID().uuidString.components(
                separatedBy: "-"
            ).first!

            self.init(
                name: randomName,
                serialNumber: randomSerialNumber,
                valueInDollars: randomValue
            )
        } else {
            self.init(name: "", serialNumber: "", valueInDollars: 0)
        }
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
            && lhs.serialNumber == rhs.serialNumber
            && lhs.valueInDollars == rhs.valueInDollars
            && lhs.dateCreated == rhs.dateCreated
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)
        try container.encode(valueInDollars, forKey: .valueInDollars)
        try container.encode(serialNumber, forKey: .serialNumber)
        try container.encode(dateCreated, forKey: .dateCreated)

        switch categoty {
        case .electronics:
            try container.encode("electronics", forKey: .category)
        case .clothing:
            try container.encode("clothing", forKey: .category)
        case .book:
            try container.encode("book", forKey: .category)
        case .other:
            try container.encode("other", forKey: .category)
        }
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        valueInDollars = try container.decode(Int.self, forKey: .valueInDollars)
        serialNumber = try container.decode(String.self, forKey: .serialNumber)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)

        let categoryString = try container.decode(
            String.self,
            forKey: .category
        )

        switch categoryString {
        case "electronics":
            categoty = .electronics
        case "clothing":
            categoty = .clothing
        case "book":
            categoty = .book
        case "other":
            categoty = .other
        default:
            categoty = .other
        }
    }
}
