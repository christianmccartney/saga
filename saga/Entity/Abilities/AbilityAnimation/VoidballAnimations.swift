//
//  VoidballAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/19/21.
//

import SpriteKit

let voidballAttackAnimation: AbilityAnimation = { caster, target, position, closure in
    let mapController = MapController.shared
    let casterPosition = caster.mapPosition
    let point: CGPoint
    if let target = target {
        point = mapController.centerOfTile(target.position.column, target.position.row)
    } else {
        point = mapController.centerOfTile(position.column, position.row)
    }
    guard let voidballTexture = EffectType.textures[EffectType.voidball],
          let explosionTextures = AnimatedEffect.textures[.voidimpact] else {
              fatalError("Failed to get Voidball resources")
          }
    
    let emitter = GravityEmitter(type: .sparks(.systemPink), acceleration: 100)
    
    voidballTexture.filteringMode = .nearest
//    emitter.targetNode(map)
    let voidballNode = Node(texture: voidballTexture)
    voidballNode.addChild(emitter)
    
    let tileAbove = mapController.centerOfTile(caster.position.column, caster.position.row + 1)
    let middlePosition = (casterPosition + tileAbove) / 2
    voidballNode.position = (casterPosition + middlePosition) / 2
    mapController.addChild(voidballNode)
    
    // Animate effect
    let direction = CGVector(dx: point.x - casterPosition.x, dy: point.y - casterPosition.y)
    let animate = SKAction.move(by: direction, duration: direction.length / 100)
    animate.timingFunction = Easing.easeOutIn.curve(.cubic)
    voidballNode.run(animate) {
        mapController.removeChildren(in: [voidballNode])
        // Explosion effect
        let explosionNode = Node(texture: explosionTextures.first!)
        let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
        explosionNode.position = point
        mapController.addChild(explosionNode)
        explosionNode.run(explosionAnimation) {
            mapController.removeChildren(in: [explosionNode])
            closure()
        }
    }
}

let voidballDeathAnimation: DeathAnimation = { entity in
    let mapController = MapController.shared
    let entityPosition = entity.mapPosition
    
    guard let voidSpark = AnimatedEffect.textures[.voidspark],
          let sparkle = AnimatedEffect.textures[.sparkle],
          var voidImpact = AnimatedEffect.textures[.voidimpact] else { return }
    
    voidImpact = voidImpact.reversed()
    let explosionNode = Node(texture: voidImpact.first!)
    let explosionAnimation = SKAction.animate(with: voidImpact, timePerFrame: 0.1)
    explosionNode.position = entityPosition
    mapController.addChild(explosionNode)
    
    let explosionShrink = SKAction.scale(by: 0.1, duration: 0.1)
    let entityShrink = SKAction.scale(by: 0.1, duration: 0.075)
    
    explosionNode.run(explosionAnimation) {
        explosionNode.run(explosionShrink) {
            mapController.removeChildren(in: [explosionNode])
            
            let sparkNode = Node(texture: voidSpark.first!)
            sparkNode.setScale(0.5)
            let sparkAnimation = SKAction.animate(with: voidSpark, timePerFrame: 0.075)
            sparkNode.position = entityPosition
            mapController.addChild(sparkNode)
            sparkNode.run(sparkAnimation) {
                mapController.removeChildren(in: [sparkNode])
                
                let sparkleNode = Node(texture: sparkle.first!)
                sparkleNode.setScale(0.5)
                let sparkleAnimation = SKAction.animate(with: sparkle, timePerFrame: 0.075)
                sparkleNode.position = entityPosition
                mapController.addChild(sparkleNode)
                sparkleNode.run(sparkleAnimation) {
                    mapController.removeChildren(in: [sparkleNode])
                }
            }
        }
        entity.spriteNode.run(entityShrink) {
            mapController.removeChild(entity)
        }
    }
}
