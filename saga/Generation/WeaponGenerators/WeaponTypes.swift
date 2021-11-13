//
//  WeaponTypes.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import Foundation

enum WeaponType {
    case sword
    case axe
    case spear
    case club
    case bow
    case staff
    case wand
    
    func property() -> WeaponProperty? {
        switch self {
        case .sword:
            return LootTable.shared.roll(table: WeaponType.swordProperties)
        case .axe:
            return LootTable.shared.roll(table: WeaponType.axeProperties)
        case .spear:
            return LootTable.shared.roll(table: WeaponType.spearProperties)
        case .club:
            return LootTable.shared.roll(table: WeaponType.clubProperties)
        case .bow:
            return LootTable.shared.roll(table: WeaponType.bowProperties)
        case .staff:
            return LootTable.shared.roll(table: WeaponType.staffProperties)
        case .wand:
            return LootTable.shared.roll(table: WeaponType.wandProperties)
        }
    }

    static let swordComponents: [WeaponComponent] = [
        .blade,
        .crossguard,
        .hilt,
        .pommel
    ]
    
    static let axeComponents: [WeaponComponent] = [
        .blade,
        .hilt,
        .pommel
    ]
    
    static let spearComponents: [WeaponComponent] = [
        .blade,
        .crossguard,
        .haft,
        .pommel
    ]
    
    static let clubComponents: [WeaponComponent] = [
        .haft,
        .hilt,
    ]
    
    static let bowComponents: [WeaponComponent] = [
        .haft,
        .string
    ]

    static let staffComponents: [WeaponComponent] = [
        .focus,
        .haft,
        .pommel
    ]

    static let wandComponents: [WeaponComponent] = [
        .focus,
        .crossguard,
        .hilt
    ]

    static let swordProperties: [WeaponProperty: Int] = [
        .normal: 100,
        .cute: 10,
        .broken: 1,
        .halved: 1,
        .large: 1,
        .huge: 1,
        .lucky: 1,
        .banished: 1,
        .intuitive: 1,
        .arithmetic: 1,
        .holy: 1,
    ]
    
    static let axeProperties: [WeaponProperty: Int] = [
        .normal: 1,
        .cute: 1,
        .broken: 1,
        .large: 1,
        .huge: 1,
        .lucky: 1,
        .banished: 1,
        .intuitive: 1,
        .arithmetic: 1,
        .holy: 1,
    ]
    
    static let spearProperties: [WeaponProperty: Int] = [
        .normal: 1,
        .cute: 1,
        .broken: 1,
        .large: 1,
        .lucky: 1,
        .banished: 1,
        .intuitive: 1,
        .arithmetic: 1,
        .holy: 1,
    ]
    
    static let clubProperties: [WeaponProperty: Int] = [
        .normal: 1,
        .cute: 1,
        .broken: 1,
        .large: 1,
        .huge: 1,
        .lucky: 1,
        .intuitive: 1,
        .holy: 1,
    ]
    
    static let bowProperties: [WeaponProperty: Int] = [
        .normal: 1,
        .cute: 1,
        .broken: 1,
        .large: 1,
        .huge: 1,
        .lucky: 1,
        .intuitive: 1,
        .arithmetic: 1,
        .holy: 1,
    ]
    
    static let staffProperties: [WeaponProperty: Int] = [
        .normal: 1,
        .cute: 1,
        .broken: 1,
        .large: 1,
        .lucky: 1,
        .intuitive: 1,
        .arithmetic: 1,
        .holy: 1,
    ]

    static let wandProperties: [WeaponProperty: Int] = [
        .normal: 1,
        .cute: 1,
        .broken: 1,
        .large: 1,
        .lucky: 1,
        .intuitive: 1,
        .arithmetic: 1,
        .holy: 1,
    ]
}
