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
        // get the new highlight
        if let newHighlight = highlight(for: entity.faction) {
            // add the highlight to the new highlighted entity
            self.highlightedEntity?.addHighlightEntity(newHighlight)
            // set the highlight
            self.highlightEntity = newHighlight
        }
    }

    private func unhighlight() {
        DispatchQueue.main.async {
            self.highlightedEntity?.map?.removeHintNodes()
            self.highlightedEntity?.map?.removeAttackNodes()
        }
        if let highlightEntity = highlightEntity {
            self.highlightedEntity?.removeHighlightEntity(highlightEntity)
            self.highlightEntity = nil
            self.highlightedEntity = nil
        }
    }
    
    func highlight(_ entity: Entity?) {
        // a new entity should be highlighted
        if let entity = entity, entity != highlightedEntity {
            highlight(entity)
        } else { // we should unhighlight the highlighted entity
            unhighlight()
        }
    }
}

extension Map {
    static let movementTileSet = TileSet(HighlightTileGroupDefinition(name: "movement", adjacencyTextureProvider: HighlightType.yellow))
    static let abilityTileSet = TileSet(HighlightTileGroupDefinition(name: "ability", adjacencyTextureProvider: HighlightType.yellow))
    
    func addMovementHints(to entity: Entity) {
        let movement = entity.check(.movement)
        addHints(to: entity, range: 0...movement, tileSet: Map.movementTileSet)
    }

    func addAbilityHints(to entity: Entity, ability: Ability) {
        let range = ability.abilityChecker.rangeCheck(entity)
        addHints(to: entity, range: range, tileSet: Map.abilityTileSet)
    }
    
    private func addHints(to entity: Entity, range: ClosedRange<Int>, tileSet: TileSet) {
        if range.lowerBound > 0 {
            
        }
        let span = (range.upperBound-range.lowerBound) * 2
        let tileMap = SKTileMapNode(tileSet: tileSet, columns: span, rows: span, tileSize: tileSet.defaultTileSize)
        tileMap.enableAutomapping = false
        tileMap.position = entity.mapPosition ?? CGPoint()
        tileMap.isUserInteractionEnabled = false
        tileMap.fillWithEdges(tileSet.tileGroups.first!)
        addHintNode(tileMap)
    }
    
    func addAttackHints(to entity: Entity, ability: Ability) {
        for e in entity.nearbyEntities(within: ability.abilityChecker.rangeCheck(entity)) {
            if let target = ability.checkAvailable(caster: entity, target: e, position: e.position) {
                if let texture = target.texture() {
                    let node = Node(texture: texture)
                    node.isUserInteractionEnabled = false
                    node.position = centerOfTile(atColumn: e.position.column, row: e.position.row)
                    addAttackNode(node)
                }
            }
        }
    }
}

//    private func addHintNodes(to entity: Entity, range: ClosedRange<Int>, hintTexture: SKTexture, addTo hintNodes: inout [Node]) {
//        let colUpperBound = entity.position.column+range.upperBound
//        let colLowerBound = entity.position.column-range.upperBound
//        let rowUpperBound = entity.position.row+range.upperBound
//        let rowLowerBound = entity.position.row-range.upperBound
//        for x in colLowerBound...colUpperBound {
//            for y in rowLowerBound...rowUpperBound {
//                if x == entity.position.column, y == entity.position.row { continue }
//                if x < 0 || x > numberOfColumns || y < 0 || y > numberOfColumns { continue }
//                if !range.contains(Position(x, y).distance(entity.position)) { continue }
//                if roomMap[y][x], entity.nearbyEntities.allSatisfy({ $0.position != Position(x, y) }) {
//                    let node = Node(texture: hintTexture)
//                    node.isUserInteractionEnabled = false
//                    node.position = centerOfTile(atColumn: x, row: y)
//                    DispatchQueue.main.async {
//                        self.addChild(node)
//                    }
//                    hintNodes.append(node)
//                }
//            }
//        }
//    }
