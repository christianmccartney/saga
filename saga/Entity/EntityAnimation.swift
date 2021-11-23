//
//  EntityAnimation.swift
//  saga
//
//  Created by Christian McCartney on 11/15/21.
//

import SpriteKit

typealias DeathAnimation = ((Entity) -> Void)

let bloodFountainAnimation: DeathAnimation = { entity in
    let mapController = MapController.shared
    let entityPosition = entity.mapPosition
    guard let explosionTextures = AnimatedEffect.textures[.bloodImpact] else { return }
    let emitter = GravityEmitter(type: .bits(.red), acceleration: 0, position: entityPosition)
    mapController.addChild(emitter)
    mapController.removeChild(entity)
    
    let explosionNode = Node(texture: explosionTextures.first!)
    let bloodExplosion = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
    explosionNode.position = entityPosition
    mapController.addChild(explosionNode)
    explosionNode.run(bloodExplosion) {
        mapController.removeChildren(in: [explosionNode])
    }
    
    let bloodPoolObject = StaticObject(type: .blood_a, position: entity.position)
    bloodPoolObject.selectable = false
    bloodPoolObject.attackable = false
    mapController.addChild(bloodPoolObject)
    bloodPoolObject.updatePosition()
    
    let waitAction = SKAction.wait(forDuration: 0.5)
    bloodPoolObject.spriteNode.run(waitAction)
    let fadeAction = SKAction.fadeOut(withDuration: 0.5)
    emitter.run(fadeAction) {
        mapController.removeChild(emitter)
    }
}
