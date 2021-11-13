//
//  LootTable.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import Foundation

class LootTable {
    static let shared = LootTable()
    private init() {}

    func roll<A>(table: [A: Int]) -> A? {
        let total = table.values.reduce(0, +)
        let rand = Int.random(in: 0..<total)
        var count = 0
        for (key, value) in table {
            count = count + value
            if rand < count {
                return key
            }
        }
        return table.first?.key
    }
}
