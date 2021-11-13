//
//  MovementAbility.swift
//  saga
//
//  Created by Christian McCartney on 11/12/21.
//

import Foundation

enum MovementAbility: AbilityProviding, CaseIterable {
    case dash
    
    var ability: Ability {
        switch self {
        case .dash:
            return Ability(name: "dash", targets: [.enemy, .friendly, .neutral, .none], abilityChecker: DashAbilityChecker())
        }
    }
}

class DashAbilityChecker: AbilityChecker {
    func damageCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta? { nil }

    func healCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta? { nil }

    func statChangeCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) { }
    
    func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 1...caster.statistics.checkModifier(.movement) * 2
    }
    
    func movementCheck(_ caster: Entity, _ target: Entity?, position: Position) -> CasterTargetMovement? {
        return CasterTargetMovement(casterNewPosition: position, targetNewPosition: pushedPosition(caster, target))
    }
    
    private func pushedPosition(_ caster: Entity, _ target: Entity?) -> Position? {
        guard let target = target else { return nil }
        let direction = target.position - caster.position
        return target.position + direction
    }
}
