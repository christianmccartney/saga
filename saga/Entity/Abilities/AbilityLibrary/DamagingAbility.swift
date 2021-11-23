//
//  DamagingAbility.swift
//  saga
//
//  Created by Christian McCartney on 11/12/21.
//

let strAttack = Ability(name: "strAttack",
                        targets: [.enemy, .friendly, .neutral],
                        abilityChecker: StrengthDamageAbilityChecker(),
                        abilityTextureName: "",
                        abilityAnimation: basicAttackAnimation)


class StrengthDamageAbilityChecker: AbilityChecker {
    override func damageCheck(_ caster: Entity, _ target: Entity?, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (nil, nil),
            targetHealthManaDelta: (Float(60 + caster.statistics.checkModifier(.strength)), nil))
    }
    
    override func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 1...1
    }
}

class IntelligenceDamageAbilityChecker: AbilityChecker {
    override var manaCost: Float? { 2.0 }

    override func damageCheck(_ caster: Entity, _ target: Entity?, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (nil, nil),
            targetHealthManaDelta: (Float(60 + caster.statistics.checkModifier(.intelligence)), nil))
    }

    override func rangeCheck(_ caster: Entity) -> ClosedRange<Int> {
        return 2...5
    }
}
