//
//  AbilityLibrary.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import Foundation

class AbilityLibrary {
    static let shared = AbilityLibrary()
    
    let BASIC_ATTACK: Ability
    let BASIC_STRENGTH_CHECKER: AbilityChecker
    
    private init() {
        self.BASIC_STRENGTH_CHECKER = StrengthDamageAbilityChecker()
        self.BASIC_ATTACK = Ability(
            name: "basic attack",
            range: 1,
            targets: [.enemy, .friendly, .neutral],
            abilityChecker: BASIC_STRENGTH_CHECKER)
    }
}
