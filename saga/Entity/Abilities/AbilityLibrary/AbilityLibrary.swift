//
//  AbilityLibrary.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

class AbilityLibrary {
    static let shared = AbilityLibrary()
    
    // Do I need to disinguish these? They can all do any of them
//    var damagingAbilities: [Ability] { DamagingAbility.allCases.map { $0.ability } }
//    var healingAbilities: [Ability] { HealingAbility.allCases.map { $0.ability } }
//    var movementAbilities: [Ability] { MovementAbility.allCases.map { $0.ability } }
    
    private init() {}
}
