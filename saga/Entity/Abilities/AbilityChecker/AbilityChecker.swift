//
//  AbilityChecker.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import Foundation

struct CasterTargetDelta {
    let casterHealthManaDelta: (Float?, Float?)
    let targetHealthManaDelta: (Float?, Float?)
}

protocol AbilityChecker {
    func damageCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) -> CasterTargetDelta?
    func healCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) -> CasterTargetDelta?
    func statChangeCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget)
}

class StrengthDamageAbilityChecker: AbilityChecker {
    func damageCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (1, 1),
            targetHealthManaDelta: (Float(1 + caster.checkModifier(.strength)), nil))
    }

    func healCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return nil
    }

    func statChangeCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) {}
}

class IntelligenceHealAbilityChecker: AbilityChecker {
    func damageCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) -> CasterTargetDelta? { return nil }

    func healCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) -> CasterTargetDelta? {
        return CasterTargetDelta(
            casterHealthManaDelta: (nil, nil),
            targetHealthManaDelta: (Float(1 + caster.checkModifier(.intelligence)), nil))
    }

    func statChangeCheck(_ caster: Statistics, _ target: Statistics, _ targetType: AbilityTarget) {}
}
