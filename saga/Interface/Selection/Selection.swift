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

    private var playerEntityHintsSubscription: AnyCancellable?

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
            playerEntityHintsSubscription?.cancel()
            playerEntityHintsSubscription = nil
            playerEntityHintsSubscription = entity.$selectedAbility.sink { ability in
                if let ability = ability {
                    entity.map?.removeMovementHints()
                    entity.map?.removeAbilityHints()
                    entity.map?.addAbilityHints(to: entity, ability: ability)
                } else {
                    entity.map?.removeAbilityHints()
                    entity.map?.addMovementHints(to: entity)
                }
                entity.addEntityHints(ability: ability)
            }
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
        let movementHintTexture = SelectionType.blue_crosshair1.texture()
        addHintNodes(to: entity, range: 0...movement, hintTexture: movementHintTexture, addTo: &movementHintNodes)
    }

    func removeMovementHints() {
        removeChildren(in: movementHintNodes)
        movementHintNodes = []
    }

    func addAbilityHints(to entity: Entity, ability: Ability) {
        let range = ability.abilityChecker.rangeCheck(entity)
        let abilityHintTexture = SelectionType.yellow_crosshair1.texture()
        addHintNodes(to: entity, range: range, hintTexture: abilityHintTexture, addTo: &abilityHintNodes)
    }
    
    func removeAbilityHints() {
        removeChildren(in: abilityHintNodes)
        abilityHintNodes = []
    }

    private func addHintNodes(to entity: Entity, range: ClosedRange<Int>, hintTexture: SKTexture, addTo hintNodes: inout [Node]) {
        let colUpperBound = entity.position.column+range.upperBound
        let colLowerBound = entity.position.column-range.upperBound
        let rowUpperBound = entity.position.row+range.upperBound
        let rowLowerBound = entity.position.row-range.upperBound
        for x in colLowerBound...colUpperBound {
            for y in rowLowerBound...rowUpperBound {
                if x == entity.position.column, y == entity.position.row { continue }
                if x < 0 || x > numberOfColumns || y < 0 || y > numberOfColumns { continue }
                if Position(x, y).distance(entity.position) < range.upperBound { continue }
                if roomMap[y][x], entity.nearbyEntities.allSatisfy({ $0.position != Position(x, y) }) {
                    let node = Node(texture: hintTexture)
                    node.isUserInteractionEnabled = false
                    node.position = centerOfTile(atColumn: x, row: y)
                    addChild(node)
                    hintNodes.append(node)
                }
            }
        }
    }
}

extension Entity {
    func addEntityHints(ability: Ability?) {
        guard let ability = ability else {
            removeEntityHints()
            return
        }
        for entity in nearbyEntities(within: ability.abilityChecker.rangeCheck(self)) {
            if let target = ability.checkAvailable(caster: self, target: entity, position: entity.position) {
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
