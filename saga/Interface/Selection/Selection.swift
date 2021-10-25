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
    var highlights: [SelectionType: HighlightEntity] = [:]
    @Published var highlightedEntity: Entity?
    var highlightEntity: HighlightEntity?
    @Published var activeEntity: Entity?

    private init() {
        for selectionType in SelectionType.allCases {
            let spriteNode = Node(texture: selectionType.texture())
            let highlightEntity = HighlightEntity(
                id: UUID(),
                spriteNode: spriteNode,
                type: selectionType,
                position: Position(0, 0)
            )
            highlightEntity.addComponent(MovableComponent())
            highlightEntity.spriteNode.isUserInteractionEnabled = true
            self.highlights[selectionType] = highlightEntity
        }
    }

    private func highlight(for faction: EntityFaction) -> HighlightEntity? {
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
        if entity.faction == .player {
            entity.map?.addMovementHints(to: entity)
            entity.addEntityHints()
        }
        // get the new highlight
        if let newHighlight = highlight(for: entity.faction) {
            // add the highlight to the new highlighted entity
            self.highlightedEntity?.addHighlightEntity(newHighlight)
            // set the highlight
            self.highlightEntity = newHighlight
        }
    }

    private func unhighlight() {
        self.highlightedEntity?.map?.removeMovementHints()
        self.highlightedEntity?.removeEntityHints()
        if let highlightEntity = highlightEntity {
            self.highlightedEntity?.removeHighlightEntity(highlightEntity)
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

extension Map {
    func addMovementHints(to entity: Entity) {
        let movement = entity.check(.movement)
        for x in entity.position.column-movement...entity.position.column+movement {
            for y in entity.position.row-movement...entity.position.row+movement {
                if x == entity.position.column, y == entity.position.row { continue }
                if x < 0 || x > numberOfColumns || y < 0 || y > numberOfColumns { continue }
                if roomMap[y][x], entity.nearbyEntities.allSatisfy({ $0.position != Position(x, y) }) {
                    let movementHintNode = Node(texture: SelectionType.blue_crosshair1.texture())
                    movementHintNode.isUserInteractionEnabled = false
                    movementHintNode.position = centerOfTile(atColumn: x, row: y)
                    addChild(movementHintNode)
                    movementHintNodes.append(movementHintNode)
                }
            }
        }
    }

    func removeMovementHints() {
        removeChildren(in: movementHintNodes)
        movementHintNodes = []
    }
}

extension Entity {
    func addEntityHints() {
        guard let ability = selectedAbility else { return }
        for entity in nearbyEntities(within: ability.range) {
            if let target = ability.checkAvailable(casting: self, target: entity) {
                if let texture = target.texture() {
                    let attackHintNode = Node(texture: texture)
                    attackHintNode.isUserInteractionEnabled = false
                    entity.spriteNode.addChild(attackHintNode)
                    entity.attackHintNode = attackHintNode
                }
            }
        }
    }

    func removeEntityHints() {
        guard let map = map else { return }
        for entity in map.entities {
            if let entityAttackHintNode = entity.attackHintNode {
                entity.spriteNode.removeChildren(in: [entityAttackHintNode])
            }
            attackHintNode = nil
        }
    }
}
