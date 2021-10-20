//
//  HighlightEntity.swift
//  saga
//
//  Created by Christian McCartney on 10/19/21.
//

import Foundation
import CoreGraphics

final class HighlightEntity: Entity {
    weak var entity: Entity?

    public init(id: UUID = UUID(),
                spriteNode: Node,
                type: SelectionType,
                position: Position = Position(0, 0),
                statistics: Statistics = Statistics(),
                entityDelegate: EntityDelegate? = nil) {
        spriteNode.name = type.name + "_" + String(describing: id)
        super.init(id: id,
                   spriteNode: spriteNode,
                   type: type,
                   position: position,
                   faction: .neutral,
                   entityDelegate: entityDelegate)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func touchDown(_ pos: CGPoint) {
        entity?.touchDown(pos)
    }
    
    public override func touchMoved(_ pos: CGPoint) {
        entity?.touchMoved(pos)
    }
    
    public override func touchUp(_ pos: CGPoint) {
        entity?.touchUp(pos)
    }
}

extension Entity {
    func addHighlightEntity(_ highlightEntity: HighlightEntity) {
        highlightEntity.entity = self
        addChild(highlightEntity)
    }

    func removeHighlightEntity(_ highlightEntity: HighlightEntity) {
        highlightEntity.entity = nil
        removeChild(highlightEntity)
    }
}
