//
//  IdleSystem.swift
//  saga
//
//  Created by Christian McCartney on 10/20/21.
//

import GameplayKit

// Turns out synchronizing animations across several places is not trivial
public class IdleSystem: GKComponentSystem<GKComponent> {
    static let shared = IdleSystem(componentClass: IdleComponent.self)

    var entities = Set<Entity>()
    var needsReset = true
    
    weak var coreScene: CoreScene?

    public override func addComponent(foundIn entity: GKEntity) {
        super.addComponent(foundIn: entity)
        guard let entity = entity as? Entity else  { return }
        entities.insert(entity)
        needsReset = true
    }

    public override func removeComponent(foundIn entity: GKEntity) {
        super.removeComponent(foundIn: entity)
        entities.remove(entity as! Entity)
    }

    // When a new entity with animations is added stop all the other idle animations and replay them to make
    // sure theyre synced
    public override func update(deltaTime seconds: TimeInterval) {
        if needsReset {
            var reversed = false
            if let entity = entities.first, let texture = entity.spriteNode.texture {
                if let index = entity.idleFrames[entity.direction]?.firstIndex(of: texture) {
                    reversed = index == 1
                }
            }
            for entity in entities {
                entity.spriteNode.removeAction(forKey: "idle")
                if let idleComponent = entity.components.compactMap({ $0 as? IdleComponent }).first {
                    if !reversed {
                        entity.spriteNode.run(SKAction.repeatForever(idleComponent.reversedIdleAction), withKey: "idle")
                    } else {
                        entity.spriteNode.run(SKAction.repeatForever(idleComponent.idleAction), withKey: "idle")

                    }
                }
            }
            needsReset = false
        }
    }
}
