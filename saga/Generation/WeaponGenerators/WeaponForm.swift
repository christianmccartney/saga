//
//  WeaponBlueprint.swift
//  saga
//
//  Created by Christian McCartney on 10/26/21.
//

import Foundation

//struct WeaponBlueprint {
//
//}

enum WeaponForm: CaseIterable {
    case straight
    case parabolic
    case cubic
    case wavy
    case twopronged
    case threepronged
    
//    func blueprint(for type: WeaponType) -> WeaponBlueprint {
//
//        return WeaponBlueprint()
//    }

    func form(for property: WeaponProperty) -> WeaponForm? {
        switch property {
        case .normal:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .cute:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .simple:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .broken:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .halved:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .large:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .huge:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .lucky:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .banished:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .intuitive:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .arithmetic:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        case .holy:
            return LootTable.shared.roll(table: WeaponForm.normalForms)
        }
    }

    static let normalForms: [WeaponForm: Int] = [
        .straight: 100,
        .parabolic: 10,
        .cubic: 10,
        .cubic: 10,
        .wavy: 1
    ]

    
}
