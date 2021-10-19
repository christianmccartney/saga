//
//  StaticObject.swift
//  saga
//
//  Created by Christian McCartney on 10/12/21.
//

import SpriteKit
import GameplayKit

class StaticObject: Object {
    public init(id: UUID = UUID(),
                type: StaticObjectType,
                position: Position = Position(0, 0),
                statistics: [EntityStatistic] = [],
                entityDelegate: EntityDelegate) {
        let texture = SKTexture(imageNamed: type.rawValue)
        texture.filteringMode = .nearest
        let spriteNode = Node(texture: texture)
        spriteNode.name = type.name + "_" + String(describing: id)
        super.init(id: id,
                   spriteNode: spriteNode,
                   type: type,
                   position: position,
                   direction: .down,
                   faction: .neutral,
                   statistics: statistics,
                   entityDelegate: entityDelegate)
        spriteNode.nodeDelegate = self
        self.addComponent(MovableComponent())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}