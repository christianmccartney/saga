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
    var abilityDeathAnimation: DeathAnimation

    public init(name: String,
                targets: [AbilityTarget],
                abilityChecker: AbilityChecker,
                abilityTextureName: String,
                abilityAnimation: @escaping AbilityAnimation = defaultAbilityAnimation,
                abilityDeathAnimation: @escaping DeathAnimation = bloodFountainAnimation) {
        self.name = name
        self.targets = targets
        self.abilityChecker = abilityChecker
        self.abilityTexture = SKTexture(imageNamed: abilityTextureName)
        self.abilityTexture.filteringMode = .nearest
        self.abilityTextureName = abilityTextureName
        self.abilityAnimation = abilityAnimation
        self.abilityDeathAnimation = abilityDeathAnimation
    }

    func checkAvailable(caster: Entity, target: Entity?, position: Position) -> AbilityTarget? {
        if abilityChecker.rangeCheck(caster).contains(caster.position.distance(position)),
           let targetIndex = targets.firstIndex(where: { $0.checkAvailable(casting: caster.faction,
                                                                           target: target?.faction) }) {
            return targets[targetIndex]
        }
        return nil
    }

    func act(from caster: Entity, on target: Entity?, position: Position, _ closure: @escaping (Bool) -> Void) {
        var target = target
        if let t = target, !t.attackable {
            target = nil
        }
        guard let targetType = checkAvailable(caster: caster, target: target, position: position) else {
            closure(false)
            return
        }
        if let manaCost = abilityChecker.manaCost, manaCost > caster.statistics.mana {
            closure(false)
            return
        }
        if let healthCost = abilityChecker.healthCost, healthCost > caster.statistics.health {
            closure(false)
            return
        }
        abilityAnimation(caster, target, position) {
            if let manaCost = self.abilityChecker.manaCost {
                self.applyManaDamage(damage: manaCost, to: caster)
            }
            if let healthCost = self.abilityChecker.healthCost {
                self.applyHealthDamage(damage: healthCost, to: caster)
            }
            
            if let damage = self.abilityChecker.damageCheck(caster, target, targetType) {
                if let casterHealthDamage = damage.casterHealthManaDelta.0 {
                    self.applyHealthDamage(damage: casterHealthDamage, to: caster)
                }
                if let casterManaDamage = damage.casterHealthManaDelta.1 {
                    self.applyManaDamage(damage: casterManaDamage, to: caster)
                }
                if let target = target {
                    if let targetHealthDamage = damage.targetHealthManaDelta.0 {
                        self.applyHealthDamage(damage: targetHealthDamage, to: target)
                    }
                    if let targetManaDamage = damage.targetHealthManaDelta.1 {
                        self.applyManaDamage(damage: targetManaDamage, to: target)
                    }
                }
            }
        
            if let heal = self.abilityChecker.healCheck(caster, target, targetType) {
                if let casterHealthHeal = heal.casterHealthManaDelta.0 {
                    self.applyHealthHeal(heal: casterHealthHeal, to: caster)
                }
                if let casterManaHeal = heal.casterHealthManaDelta.1 {
                    self.applyManaHeal(heal: casterManaHeal, to: caster)
                }
                if let target = target {
                    if let targetHealthHeal = heal.targetHealthManaDelta.0 {
                        self.applyHealthHeal(heal: targetHealthHeal, to: target)
                    }
                    if let targetManaHeal = heal.targetHealthManaDelta.1 {
                        self.applyManaHeal(heal: targetManaHeal, to: target)
                    }
                }
            }
        
    //        self.abilityChecker.statChangeCheck(caster, target, targetType)

//            if let movement = self.abilityChecker.movementCheck(caster, target, position: position) {
//                if let casterNewPosition = movement.casterNewPosition {
//                    caster.move(to: casterNewPosition) {}
//                }
//                if let target = target, let targetNewPosition = movement.targetNewPosition {
//                    target.move(to: targetNewPosition) {}
//                }
//            }
            
            closure(true)
        }
    }

    private func applyHealthDamage(damage: Float, to entity: Entity) {
        guard let position = entity.mapPosition else { return }
        entity.statistics.health -= damage
        entity.applyDamage(damage: damage, position: position)
        if entity.statistics.health < 0 {
            ActorSystem.shared.enqueueAction(abilityDeathAnimation, entity)
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
