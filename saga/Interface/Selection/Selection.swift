//
//  Selection.swift
//  Saga
//
//  Created by Christian McCartney on 5/26/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit
import Combine

class Selection: ObservableObject {
    static let shared = Selection()
    var highlights: [SelectionType: Entity] = [:]
    @Published var highlightedEntity: Entity?
    var highlightEntity: Entity?

    private init() {
        for selectionType in SelectionType.allCases {
            let texture = SKTexture(imageNamed: selectionType.rawValue)
            let spriteNode = Node(texture: texture)
            let highlightEntity = Entity(
                id: UUID(),
                spriteNode: spriteNode,
                type: selectionType,
                position: Position(0, 0),
                faction: .neutral,
                statistics: []
            )
            highlightEntity.addComponent(MovableComponent())
            highlightEntity.spriteNode.isUserInteractionEnabled = true
            self.highlights[selectionType] = highlightEntity
        }
    }

    private func highlight(for faction: EntityFaction) -> Entity? {
        switch faction {
        case .enemy:
            return Selection.shared.highlights[.red_entity_select1]
        case .player:
            return Selection.shared.highlights[.green_entity_select1]
        case .friendly:
            return Selection.shared.highlights[.green_entity_select1]
        case .neutral:
            return Selection.shared.highlights[.yellow_entity_select1]
        }
    }

    private func highlight(_ entity: Entity) {
        // remove the highlight from the old entity
        unhighlight()
        // set the new entity to be highlighted as the highlighted entity
        self.highlightedEntity = entity
        // get the new highlight
        if let newHighlight = highlight(for: entity.faction) {
            // add the highlight to the new highlighted entity
            self.highlightedEntity?.addChild(newHighlight)
            // set the highlight
            self.highlightEntity = newHighlight
        }
    }

    private func unhighlight() {
        if let highlightEntity = highlightEntity {
            self.highlightedEntity?.removeChild(highlightEntity)
            self.highlightEntity = nil
            self.highlightedEntity = nil
        }
    }

    func highlight(_ entity: Entity?) {
        // a new entity should be highlighted
        if let entity = entity {
            highlight(entity)
        } else { // we should unhighlight the highlighted entity
            unhighlight()
        }
    }
}

protocol Selectable {
    var entityDescription: String { get }
}
