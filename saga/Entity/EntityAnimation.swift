//
//  EntityAnimation.swift
//  saga
//
//  Created by Christian McCartney on 11/15/21.
//

import SpriteKit

//    emitter.particleColorSequence = SKKeyframeSequence(keyframeValues: [SKColor.yellow,
//                                                                        SKColor.red,
//                                                                        SKColor.lightGray,
//                                                                        SKColor.gray],
//                                                       times: [0, 0.25, 0.5, 1])

typealias DeathAnimation = ((Entity) -> Void)

let bloodFountainAnimation: DeathAnimation = { entity in
    guard let map = entity.map, let entityPosition = entity.mapPosition,
          let explosionTextures = AnimatedEffect.textures[.bloodImpact],
          let gameState = map.mapSet?.gameState else { return }
    let emitter = GravityEmitter(type: .bits(.red), acceleration: 0, position: entityPosition)
    map.addChild(emitter)
    map.mapSet?.gameState?.removeChild(entity)
    
    let explosionNode = Node(texture: explosionTextures.first!)
    let bloodExplosion = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
    explosionNode.position = entityPosition
    map.addChild(explosionNode)
    explosionNode.run(bloodExplosion) {
        map.removeChildren(in: [explosionNode])
    }
    
    let bloodPoolObject = StaticObject(type: .blood_a, position: entity.position, entityDelegate: gameState)
    bloodPoolObject.selectable = false
    bloodPoolObject.attackable = false
    gameState.addChild(bloodPoolObject)
    bloodPoolObject.updatePosition()
    
    let waitAction = SKAction.wait(forDuration: 0.5)
    bloodPoolObject.spriteNode.run(waitAction)
    let fadeAction = SKAction.fadeOut(withDuration: 0.5)
    emitter.run(fadeAction) {
        map.removeChild(emitter)
    }
}
