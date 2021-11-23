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
    weak var gameState: GameState!
    
    private var mapController: MapController { MapController.shared }
    
    private func highlight(for faction: EntityFaction) -> SelectionType {
        switch faction {
        case .player:
            return .green_entity_select1
        case .friendly:
            return .green_entity_select1
        case .neutral:
            return .yellow_entity_select1
        case .enemy:
            return .red_entity_select1
        }
    }

    func unhighlight() {
        if let highlightNode = gameState.highlightNode {
            gameState.highlightedEntity = nil
            gameState.removeChildren(in: [highlightNode])
        }
    }
    
    func highlight(_ entity: Entity) {
        unhighlight()
        let selection = SKTexture(imageNamed: highlight(for: entity.faction).rawValue)
        let node = SKSpriteNode(texture: selection)
        node.position = entity.mapPosition
        node.isUserInteractionEnabled = false
        gameState.highlightNode = node
        gameState.highlightedEntity = entity
        gameState.addChild(node)
    }
}

extension MapController {
    static let movementTileSet = TileSet(HighlightTileGroupDefinition(name: "movement", adjacencyTextureProvider: HighlightType.blue))
    static let abilityTileSet = TileSet(HighlightTileGroupDefinition(name: "ability", adjacencyTextureProvider: HighlightType.yellow))
    static let innerAbilityTileSet = TileSet(HighlightTileGroupDefinition(name: "inner_ability", adjacencyTextureProvider: HighlightType.innerYellow))
    
    func addMovementHints(to entity: Entity) {
        let movement = entity.check(.movement)
        let span = movement * 2 + 1
        addHints(to: entity, span: span, tileSet: MapController.movementTileSet)
    }

    func addAbilityHints(to entity: Entity, ability: Ability) {
        let range = ability.abilityChecker.rangeCheck(entity)
        if range.lowerBound > 1 {
            let innerSpan = range.lowerBound * 2 - 1
            addHints(to: entity, span: innerSpan, tileSet: MapController.innerAbilityTileSet)
        }
        let span = range.upperBound * 2 + 1
        addHints(to: entity, span: span, tileSet: MapController.abilityTileSet)
    }
    
    private func addHints(to entity: Entity, span: Int, tileSet: TileSet) {
        let tileMap = SKTileMapNode(tileSet: tileSet, columns: span, rows: span, tileSize: tileSet.defaultTileSize)
        tileMap.enableAutomapping = false
        tileMap.position = entity.mapPosition
        tileMap.isUserInteractionEnabled = false
        tileMap.fillCircle(tileSet.tileGroups.first!)
        tileMap.alpha = 0.5
        addHintNode(tileMap)
    }
    
    func addAttackHints(to entity: Entity, ability: Ability) {
        for e in entity.nearbyEntities(within: ability.abilityChecker.rangeCheck(entity)) where e.selectable {
            if let target = ability.checkAvailable(caster: entity, target: e, position: e.position) {
                if let texture = target.texture() {
                    let node = SKSpriteNode(texture: texture)
                    node.isUserInteractionEnabled = false
                    node.position = map.centerOfTile(atColumn: e.position.column, row: e.position.row)
                    addAttackNode(node)
                }
            }
        }
    }
}


/*
 //
 //    var highlights: [SelectionType: HighlightEntity] = [:]
 //    @Published var highlightedEntity: Entity? {
 //        didSet {
 //            print("highlighted \(highlightedEntity)")
 //        }
 //    }
 //    var highlightEntity: HighlightEntity?
 //    @Published weak var activeEntity: Entity?

     private var playerEntityHintsSubscription: AnyCancellable?

     private init() {
 //        for selectionType in SelectionType.allCases {
 //            let spriteNode = Node(texture: selectionType.texture())
 //            let highlightEntity = HighlightEntity(
 //                id: UUID(),
 //                spriteNode: spriteNode,
 //                type: selectionType,
 //                position: Position(0, 0)
 //            )
 //            highlightEntity.addComponent(MovableComponent())
 //            highlightEntity.spriteNode.isUserInteractionEnabled = true
 //            self.highlights[selectionType] = highlightEntity
 //        }
     }

 //    private func highlight(for faction: EntityFaction) -> HighlightEntity? {
 //        switch faction {
 //        case .enemy:
 //            return Selection.shared.highlights[.red_entity_select1]
 //        case .player:
 //            return Selection.shared.highlights[.green_entity_select1]
 //        case .friendly:
 //            return Selection.shared.highlights[.green_entity_select1]
 //        case .neutral:
 //            return Selection.shared.highlights[.yellow_entity_select1]
 //        }
 //    }
     
     private func highlight(for faction: EntityFaction) -> SelectionType {
         switch faction {
         case .player:
             return .green_entity_select1
         case .friendly:
             return .green_entity_select1
         case .neutral:
             return .yellow_entity_select1
         case .enemy:
             return .red_entity_select1
         }
     }

     private func highlight(_ entity: Entity) {
         // remove the highlight from the old entity
         unhighlight()
         // set the new entity to be highlighted as the highlighted entity
         gameState.highlightedEntity = entity

         if entity.faction == .player {
             if let ability = entity.selectedAbility {
                 mapController.removeHintNodes()
                 mapController.removeAttackNodes()
                 mapController.addAbilityHints(to: entity, ability: ability)
                 mapController.addAttackHints(to: entity, ability: ability)
             } else {
                 mapController.removeHintNodes()
                 mapController.removeAttackNodes()
                 mapController.addMovementHints(to: entity)
             }
         }
         // get the new highlight
         let highlightType = highlight(for: entity.faction)
             // add the highlight to the new highlighted entity
 //            self.highlightedEntity?.addHighlightEntity(newHighlight)
             // set the highlight
         gameState.highlightNode = SKSpriteNode(texture: SKTexture(imageNamed: highlightType.rawValue))
     }

     private func unhighlight() {
         mapController.removeHintNodes()
         mapController.removeAttackNodes()
         if gameState.highlightNode != nil {
 //            self.highlightedEntity?.removeHighlightEntity(highlightEntity)
             gameState.highlightNode = nil
             gameState.highlightedEntity = nil
         }
     }
     
     // TODO 9: This almost certainly needs a fix, when the turns are cycling quickly sometimes
     // it will remove an entity while we are highlighting the correct entity, thereby unselecting it.
     func highlight(_ entity: Entity?, set: Bool = false) {
         // a new entity should be highlighted
         if let entity = entity, entity != gameState.highlightedEntity {
             highlight(entity)
         } else if let entity = entity, set {
             highlight(entity)
         } else { // we should unhighlight the highlighted entity
             unhighlight()
         }
     }
 
 
 */
