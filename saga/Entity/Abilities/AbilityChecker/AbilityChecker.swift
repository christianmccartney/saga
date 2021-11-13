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

struct CasterTargetMovement {
    let casterNewPosition: Position?
    let targetNewPosition: Position?
}

protocol AbilityChecker {
    func damageCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta?
    func healCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget) -> CasterTargetDelta?
    func statChangeCheck(_ caster: Entity, _ target: Entity, _ targetType: AbilityTarget)
    func rangeCheck(_ caster: Entity) -> ClosedRange<Int>
    func movementCheck(_ caster: Entity, _ target: Entity?, position: Position) -> CasterTargetMovement?
}
