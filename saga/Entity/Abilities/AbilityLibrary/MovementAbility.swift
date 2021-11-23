//
//  MovementAbility.swift
//  saga
//
//  Created by Christian McCartney on 11/12/21.
//

let dash = Ability(name: "dash",
                   targets: [.enemy, .friendly, .neutral, .none],
                   abilityChecker: DashAbilityChecker(),
                   abilityTextureName: "",
                   abilityAnimation: dashAnimation)

class DashAbilityChecker: AbilityChecker {
    override func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 1...caster.statistics.checkModifier(.movement) * 2
    }
    
    override func movementCheck(_ caster: Entity, _ target: Entity?, position: Position) -> CasterTargetMovement? {
        return CasterTargetMovement(casterNewPosition: position, targetNewPosition: pushedPosition(caster, target))
    }
    
    private func pushedPosition(_ caster: Entity, _ target: Entity?) -> Position? {
        guard let target = target else { return nil }
        let direction = target.position - caster.position
        return target.position + direction
    }
}
