//
//  Ability.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//


class Ability {
    var name: String
    var range: Int
    var targets: [AbilityTarget]
    var abilityChecker: AbilityChecker

    public init(name: String, range: Int, targets: [AbilityTarget], abilityChecker: AbilityChecker) {
        self.name = name
        self.range = range
        self.targets = targets
        self.abilityChecker = abilityChecker
    }

    func checkAvailable(casting: Entity, target: Entity) -> AbilityTarget? {
        if casting.position.distance(target.position) <= range,
           let targetIndex = targets.firstIndex(where: { $0.checkAvailable(casting: casting.faction,
                                                                           target: target.faction) }) {
            return targets[targetIndex]
        }
        return nil
    }

    func act(from caster: Entity, on target: Entity, target targetType: AbilityTarget) {
        if let damage = abilityChecker.damageCheck(caster.statistics, target.statistics, targetType) {
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
    
        if let heal = abilityChecker.healCheck(caster.statistics, target.statistics, targetType) {
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
    
        abilityChecker.statChangeCheck(caster.statistics, target.statistics, targetType)
    }
}
