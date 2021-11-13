//
//  DamagingAbility.swift
//  saga
//
//  Created by Christian McCartney on 11/12/21.
//

import Foundation

enum DamagingAbility: AbilityProviding, CaseIterable {
    case strAttack
    
    var ability: Ability {
        switch self {
        case .strAttack:
            return Ability(name: "strAttack", targets: [.enemy, .friendly, .neutral], abilityChecker: StrengthDamageAbilityChecker())
        }
    }
}


class StrengthDamageAbilityChecker: AbilityChecker {
    func damageCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (1, 1),
            targetHealthManaDelta: (Float(1 + caster.statistics.checkModifier(.strength)), nil))
    }

    func healCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta? { nil }

    func statChangeCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) {}
    
    func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 1...1
    }
    
    func movementCheck(_ caster: Entity, _ target: Entity?, position: Position) -> CasterTargetMovement? { nil }
}
