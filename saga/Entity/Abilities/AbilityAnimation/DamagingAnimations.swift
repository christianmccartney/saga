//
//  DamagingAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/14/21.
//

import SpriteKit

@MainActor
let basicAttackAnimation: AbilityAnimation = { caster, target, position in
    guard let map = caster.map, let casterPosition = caster.mapPosition else { return }
    let direction: CGPoint
    if let target = target {
        direction = map.centerOfTile(atColumn: target.position.column, row: target.position.row)
    } else {
        direction = map.centerOfTile(atColumn: position.column, row: position.row)
    }
    let bopAction = SKAction.move(by: CGVector(dx: (direction.x - casterPosition.x)/2,
                                               dy: (direction.y - casterPosition.y)/2),
                                  duration: 0.125)
    let reverseAction = bopAction.reversed()
    let bopGroup = SKAction.sequence([bopAction, reverseAction])
    await caster.spriteNode.run(bopGroup)
}

@MainActor
let fireballAttackAnimation: AbilityAnimation = { caster, target, position in
    guard let map = caster.map, let casterPosition = caster.mapPosition else { return }
    let point: CGPoint
    if let target = target {
        point = map.centerOfTile(atColumn: target.position.column, row: target.position.row)
    } else {
        point = map.centerOfTile(atColumn: position.column, row: position.row)
    }
    guard let fireballTexture = EffectType.textures[EffectType.fireball],
          let particleEmitter = SKEmitterNode(fileNamed: "FireballSpark"),
          let explosionTextures = AnimatedEffect.textures[.fireImpact] else {
              fatalError("Failed to get Fireball resources")
          }
    fireballTexture.filteringMode = .nearest
    particleEmitter.targetNode = map
    let fireballNode = Node(texture: fireballTexture)
    fireballNode.addChild(particleEmitter)
    
    let tileAbove = map.centerOfTile(atColumn: caster.position.column, row: caster.position.row + 1)
    let middlePosition = (casterPosition + tileAbove) / 2
    fireballNode.position = (casterPosition + middlePosition) / 2
    map.addChild(fireballNode)
    
    // Animate effect
    let direction = CGVector(dx: point.x - casterPosition.x, dy: point.y - casterPosition.y)
    let animate = SKAction.move(by: direction, duration: direction.length / 100)
    animate.timingFunction = Easing.easeIn.curve(.quintic)
    await fireballNode.run(animate)
    map.removeChildren(in: [fireballNode])

    // Explosion effect
    let explosionNode = Node(texture: explosionTextures.first!)
    let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
    explosionNode.position = point
    map.addChild(explosionNode)
    await explosionNode.run(explosionAnimation)
    map.removeChildren(in: [explosionNode])
}

@MainActor
let voidballAttackAnimation: AbilityAnimation = { caster, target, position in
    guard let map = caster.map, let casterPosition = caster.mapPosition else { return }
    let point: CGPoint
    if let target = target {
        point = map.centerOfTile(atColumn: target.position.column, row: target.position.row)
    } else {
        point = map.centerOfTile(atColumn: position.column, row: position.row)
    }
    guard let voidballTexture = EffectType.textures[EffectType.voidball],
          let explosionTextures = AnimatedEffect.textures[.voidImpact] else {
              fatalError("Failed to get Voidball resources")
          }
    
    let emitter = GravityEmitter(type: .sparks, acceleration: 100)
    
    voidballTexture.filteringMode = .nearest
    emitter.targetNode(map)
    let voidballNode = Node(texture: voidballTexture)
    voidballNode.addChild(emitter)
    
    let tileAbove = map.centerOfTile(atColumn: caster.position.column, row: caster.position.row + 1)
    let middlePosition = (casterPosition + tileAbove) / 2
    voidballNode.position = (casterPosition + middlePosition) / 2
    map.addChild(voidballNode)
    
    // Animate effect
    let direction = CGVector(dx: point.x - casterPosition.x, dy: point.y - casterPosition.y)
    let animate = SKAction.move(by: direction, duration: direction.length / 100)
    animate.timingFunction = Easing.easeOutIn.curve(.cubic)
    await voidballNode.run(animate)
    map.removeChildren(in: [voidballNode])

    // Explosion effect
    let explosionNode = Node(texture: explosionTextures.first!)
    let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
    explosionNode.position = point
    map.addChild(explosionNode)
    await explosionNode.run(explosionAnimation)
    map.removeChildren(in: [explosionNode])
}
