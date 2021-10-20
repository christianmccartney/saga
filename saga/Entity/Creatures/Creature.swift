//
//  Creature.swift
//  saga
//
//  Created by Christian McCartney on 10/12/21.
//

import SpriteKit
import GameplayKit

final class Creature: Entity {
    public init(id: UUID = UUID(),
                type: CreatureType,
                faction: EntityFaction = .neutral,
                direction: EntityDirection = .down,
                position: Position = Position(0, 0),
                statistics: [EntityStatistic],
                entityDelegate: EntityDelegate? = nil) {
        let texture = SKTexture(imageNamed: type.name + direction.toString())
        texture.filteringMode = .nearest
        let spriteNode = Node(texture: texture)
        spriteNode.name = type.name + "_" + String(describing: id)

        var textures: [EntityDirection: [SKTexture]] = [:]
        for direction in EntityDirection.directions {
            let texture1 = SKTexture(imageNamed: type.name + direction.toString())
            let texture2 = SKTexture(imageNamed: type.name + direction.toString2())
            texture1.filteringMode = .nearest
            texture2.filteringMode = .nearest
            textures[direction] = [texture1, texture2]
        }
        super.init(id: id,
                   spriteNode: spriteNode,
                   type: type,
                   position: position,
                   direction: direction,
                   faction: faction,
                   statistics: statistics,
                   idleFrames: textures,
                   entityDelegate: entityDelegate)
        self.addComponent(IdleComponent())
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
