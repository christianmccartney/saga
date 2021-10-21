//
//  DynamicObject.swift
//  saga
//
//  Created by Christian McCartney on 10/12/21.
//

import SpriteKit
import GameplayKit

class DynamicObject: Object {
    public init(id: UUID = UUID(),
                type: DynamicObjectType,
                position: Position = Position(0, 0),
                statistics: Statistics = Statistics(),
                entityDelegate: EntityDelegate) {

        let texture1 = SKTexture(imageNamed: type.name + "1")
        let texture2 = SKTexture(imageNamed: type.name + "2")
        texture1.filteringMode = .nearest
        texture2.filteringMode = .nearest

        let spriteNode = Node(texture: texture1)
        spriteNode.name = type.name + "_" + String(describing: id)
        
        super.init(id: id,
                   spriteNode: spriteNode,
                   type: type,
                   position: position,
                   direction: .down,
                   faction: .neutral,
                   statistics: statistics,
                   idleFrames: [.down: [texture1, texture2]],
                   entityDelegate: entityDelegate)
        self.addComponent(IdleComponent())
        System.shared.addEntity(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
