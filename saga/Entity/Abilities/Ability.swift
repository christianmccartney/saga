//
//  Ability.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SpriteKit

class Ability {
    var name: String
    var targets: [AbilityTarget]
    var abilityChecker: AbilityChecker
    var abilityTextureName: String
    var abilityTexture: SKTexture
    var abilityAnimation: AbilityAnimation

    public init(name: String,
                targets: [AbilityTarget],
                abilityChecker: AbilityChecker,
                abilityTextureName: String,
                abilityAnimation: @escaping AbilityAnimation = defaultAbilityAnimation) {
        self.name = name
        self.targets = targets
        self.abilityChecker = abilityChecker
        self.abilityTexture = SKTexture(imageNamed: abilityTextureName)
        self.abilityTexture.filteringMode = .nearest
        self.abilityTextureName = abilityTextureName
        self.abilityAnimation = abilityAnimation
    }

    func checkAvailable(caster: Entity, target: Entity?, position: Position) -> AbilityTarget? {
        if abilityChecker.rangeCheck(caster).contains(caster.position.distance(position)),
           let targetIndex = targets.firstIndex(where: { $0.checkAvailable(casting: caster.faction,
                                                                           target: target?.faction) }) {
            return targets[targetIndex]
        }
        return nil
    }

    func act(from caster: Entity, on target: Entity?, position: Position) async -> Bool {
        guard let targetType = checkAvailable(caster: caster, target: target, position: position) else { return false }
        if let manaCost = abilityChecker.manaCost, manaCost > caster.statistics.mana { return false }
        if let healthCost = abilityChecker.healthCost, healthCost > caster.statistics.health { return false }
        await abilityAnimation(caster, target, position)
        
        if let manaCost = abilityChecker.manaCost {
            applyManaDamage(damage: manaCost, to: caster)
        }
        if let healthCost = abilityChecker.healthCost {
            applyHealthDamage(damage: healthCost, to: caster)
        }
        
        if let damage = abilityChecker.damageCheck(caster, target, targetType) {
            if let casterHealthDamage = damage.casterHealthManaDelta.0 {
                applyHealthDamage(damage: casterHealthDamage, to: caster)
            }
            if let casterManaDamage = damage.casterHealthManaDelta.1 {
                applyManaDamage(damage: casterManaDamage, to: caster)
            }
            if let target = target {
                if let targetHealthDamage = damage.targetHealthManaDelta.0 {
                    applyHealthDamage(damage: targetHealthDamage, to: target)
                }
                if let targetManaDamage = damage.targetHealthManaDelta.1 {
                    applyManaDamage(damage: targetManaDamage, to: target)
                }
            }
        }
    
        if let heal = abilityChecker.healCheck(caster, target, targetType) {
            if let casterHealthHeal = heal.casterHealthManaDelta.0 {
                applyHealthHeal(heal: casterHealthHeal, to: caster)
            }
            if let casterManaHeal = heal.casterHealthManaDelta.1 {
                applyManaHeal(heal: casterManaHeal, to: caster)
            }
            if let target = target {
                if let targetHealthHeal = heal.targetHealthManaDelta.0 {
                    applyHealthHeal(heal: targetHealthHeal, to: target)
                }
                if let targetManaHeal = heal.targetHealthManaDelta.1 {
                    applyManaHeal(heal: targetManaHeal, to: target)
                }
            }
        }
    
//        abilityChecker.statChangeCheck(caster, target, targetType)

        if let movement = abilityChecker.movementCheck(caster, target, position: position) {
            if let casterNewPosition = movement.casterNewPosition {
                await caster.move(to: casterNewPosition)
            }
            if let target = target, let targetNewPosition = movement.targetNewPosition {
                await target.move(to: targetNewPosition)
            }
        }

        return true
    }

    private func applyHealthDamage(damage: Float, to entity: Entity) {
        guard let position = entity.mapPosition else { return }
        entity.statistics.health -= damage
        entity.applyDamage(damage: damage, position: position)
        if entity.statistics.health < 0 {
            ActorSystem.shared.enqueueAction(bloodFountainAnimation, entity)
        }
    }

    private func applyHealthHeal(heal: Float, to entity: Entity) {
        guard let position = entity.mapPosition else { return }
        entity.statistics.health += heal
        entity.applyHeal(heal: heal, position: position)
    }
    
    private func applyManaDamage(damage: Float, to entity: Entity) {
        entity.statistics.mana -= damage
    }

    private func applyManaHeal(heal: Float, to entity: Entity) {
        entity.statistics.mana += heal
    }
}
