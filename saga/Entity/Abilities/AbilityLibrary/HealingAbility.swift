//
//  HealingAbility.swift
//  saga
//
//  Created by Christian McCartney on 11/12/21.
//

import Foundation

enum HealingAbility: AbilityProviding, CaseIterable {
    case intHeal
    
    var ability: Ability {
        switch self {
        case .intHeal:
            return Ability(name: "heal", targets: [.enemy, .friendly, .neutral], abilityChecker: IntelligenceHealAbilityChecker())
        }
    }
}

class IntelligenceHealAbilityChecker: AbilityChecker {
    func damageCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta? { nil }

    func healCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (nil, nil),
            targetHealthManaDelta: (Float(1 + caster.statistics.checkModifier(.intelligence)), nil))
    }

    func statChangeCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) {}
    
    func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 1...2
    }
    
    func movementCheck(_ caster: Entity, _ target: Entity?, position: Position) -> CasterTargetMovement? { nil }
}
