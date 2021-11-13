//
//  Weapons.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import Foundation

protocol Weapon {
    var type: WeaponType { get }
    var components: [WeaponComponent] { get }
}

struct Sword: Weapon {
    var type: WeaponType = .sword
    var components: [WeaponComponent] = [.blade, .crossguard, .hilt, .pommel]
}

struct Spear: Weapon {
    var type: WeaponType = .sword
    var components: [WeaponComponent] = [.blade, .crossguard, .hilt, .pommel]
}
