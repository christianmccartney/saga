//
//  Ability.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

class Ability {
    var name: String
    var targets: [AbilityTarget]
    var abilityChecker: AbilityChecker

    public init(name: String, targets: [AbilityTarget], abilityChecker: AbilityChecker) {
        self.name = name
        self.targets = targets
        self.abilityChecker = abilityChecker
    }

    func checkAvailable(caster: Entity, target: Entity?, position: Position) -> AbilityTarget? {
        if abilityChecker.rangeCheck(caster).contains(caster.position.distance(position)),
           let targetIndex = targets.firstIndex(where: { $0.checkAvailable(casting: caster.faction,
                                                                           target: target?.faction) }) {
            return targets[targetIndex]
        }
        return nil
    }

    func act(from caster: Entity, on target: Entity?, position: Position) -> Bool {
        guard let targetType = checkAvailable(caster: caster, target: target, position: position) else { return false }
        
        if let target = target, let damage = abilityChecker.damageCheck(caster, target, targetType) {
            if let casterHealthDamage = damage.casterHealthManaDelta.0 {
                caster.statistics.health -= casterHealthDamage
                caster.entityHealthDamageSubject.send(casterHealthDamage)
            }
            if let casterManaDamage = damage.casterHealthManaDelta.1 {
                caster.statistics.mana -=  casterManaDamage
                caster.entityManaDamageSubject.send(casterManaDamage)
            }
            if let targetHealthDamage = damage.targetHealthManaDelta.0 {
                target.statistics.health -= targetHealthDamage
                target.entityHealthDamageSubject.send(targetHealthDamage)
            }
            if let targetManaDamage = damage.targetHealthManaDelta.1 {
                target.statistics.mana -= targetManaDamage
                caster.entityManaDamageSubject.send(targetManaDamage)
            }
        }
    
        if let target = target, let heal = abilityChecker.healCheck(caster, target, targetType) {
            if let casterHealthHeal = heal.casterHealthManaDelta.0 {
                caster.statistics.health += casterHealthHeal
                caster.entityHealthHealSubject.send(casterHealthHeal)
            }
            if let casterManaHeal = heal.casterHealthManaDelta.1 {
                caster.statistics.mana += casterManaHeal
                caster.entityManaHealSubject.send(casterManaHeal)
            }
            if let targetHealthHeal = heal.targetHealthManaDelta.0 {
                target.statistics.health += targetHealthHeal
                target.entityHealthHealSubject.send(targetHealthHeal)
            }
            if let targetManaHeal = heal.targetHealthManaDelta.1 {
                target.statistics.mana += targetManaHeal
                target.entityManaHealSubject.send(targetManaHeal)
            }
        }
    
//        abilityChecker.statChangeCheck(caster, target, targetType)

        if let movement = abilityChecker.movementCheck(caster, target, position: position) {
            if let casterNewPosition = movement.casterNewPosition {
                caster.move(to: casterNewPosition, {})
            }
            if let target = target, let targetNewPosition = movement.targetNewPosition {
                target.move(to: targetNewPosition, {})
            }
        }

        return true
    }
}
