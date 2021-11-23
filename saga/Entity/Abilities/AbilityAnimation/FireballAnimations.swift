//
//  FireballAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/19/21.
//

import SpriteKit

let fireballAttackAnimation: AbilityAnimation = { caster, target, position, closure in
    guard let map = caster.map, let casterPosition = caster.mapPosition else { return }
    let point: CGPoint
    if let target = target {
        point = map.centerOfTile(atColumn: target.position.column, row: target.position.row)
    } else {
        point = map.centerOfTile(atColumn: position.column, row: position.row)
    }
    guard let fireballTexture = EffectType.textures[EffectType.fireball],
          let explosionTextures = AnimatedEffect.textures[.fireImpact] else {
              fatalError("Failed to get Fireball resources")
          }
    let particleEmitter = SKEmitterNode()
    EmitterType.fire(.orange).setting(for: particleEmitter)
    fireballTexture.filteringMode = .nearest
    particleEmitter.targetNode = map
    let fireballNode = Node(texture: fireballTexture)
    fireballNode.setScale(0.75)
    fireballNode.addChild(particleEmitter)
    
    let tileAbove = map.centerOfTile(atColumn: caster.position.column, row: caster.position.row + 1)
    let middlePosition = (casterPosition + tileAbove) / 2
    fireballNode.position = (casterPosition + middlePosition) / 2
    map.addChild(fireballNode)
    
    // Animate effect
    let direction = CGVector(dx: point.x - casterPosition.x, dy: point.y - casterPosition.y)
    let animate = SKAction.move(by: direction, duration: direction.length / 100)
    animate.timingFunction = Easing.easeIn.curve(.quintic)
    fireballNode.run(animate) {
        map.removeChildren(in: [fireballNode])
        // Explosion effect
        let explosionNode = Node(texture: explosionTextures.first!)
        explosionNode.setScale(0.75)
        let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
        explosionNode.position = point
        map.addChild(explosionNode)
        explosionNode.run(explosionAnimation) {
            map.removeChildren(in: [explosionNode])
            closure()
        }
    }
}

let fireballDeathAnimation: DeathAnimation = { entity in
    guard let map = entity.map, let entityPosition = entity.mapPosition,
          let fireSpark = AnimatedEffect.textures[.fireSpark],
          let fireBurn = AnimatedEffect.textures[.fireBurn],
          let gameState = map.mapSet?.gameState else { return }
    let emitter = GravityEmitter(type: .bits(.gray), acceleration: 75, position: entityPosition)
    map.addChild(emitter)
    map.mapSet?.gameState?.removeChild(entity)

    let sparkNode = Node(texture: fireSpark.first!)
    let spark = SKAction.animate(with: fireSpark, timePerFrame: 0.1)
    sparkNode.position = entityPosition
    map.addChild(sparkNode)
    sparkNode.run(spark) {
        map.removeChildren(in: [sparkNode])
    }

    let scorchObject = StaticObject(type: .scorch_a, position: entity.position, entityDelegate: gameState)
    scorchObject.selectable = false
    scorchObject.attackable = false
    gameState.addChild(scorchObject)
    scorchObject.updatePosition()
    
    let fireNode = Node(texture: fireBurn.first!)
    let animate = SKAction.animate(with: fireBurn, timePerFrame: 0.075)
    let burn = SKAction.repeat(animate, count: Int.random(in: 3...7))
    fireNode.setScale(0.5)
    fireNode.position = CGPoint(x: CGFloat.random(in: -5...5),
                                y: CGFloat.random(in: -5...5))
    scorchObject.spriteNode.addChild(fireNode)
    fireNode.run(burn) {
        scorchObject.spriteNode.removeChildren(in: [fireNode])
    }

    let waitAction = SKAction.wait(forDuration: 0.5)
    scorchObject.spriteNode.run(waitAction)
    let fadeAction = SKAction.fadeOut(withDuration: 0.5)
    emitter.run(fadeAction) {
        map.removeChild(emitter)
    }
}
