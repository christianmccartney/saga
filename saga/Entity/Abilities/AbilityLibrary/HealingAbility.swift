//
//  HealingAbility.swift
//  saga
//
//  Created by Christian McCartney on 11/12/21.
//

let intHeal = Ability(name: "heal", targets: [.enemy, .friendly, .neutral], abilityChecker: IntelligenceHealAbilityChecker(), abilityTextureName: "")

class IntelligenceHealAbilityChecker: AbilityChecker {
    override var manaCost: Float? { 16.0 }
    override func healCheck(_ caster: Entity, _ target: Entity?, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (10, nil),
            targetHealthManaDelta: (Float(1 + caster.statistics.checkModifier(.intelligence)), nil))
    }

    override func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 1...2
    }
}
