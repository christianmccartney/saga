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
            mapController.removeChildren(in: [highlightNode])
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
        mapController.addChild(node)
    }
}

extension MapController {
    static let movementTileSet = TileSet(HighlightTileGroupDefinition(
        name: "movement", adjacencyTextureProvider: HighlightType.blue))
    static let abilityTileSet = TileSet(HighlightTileGroupDefinition(
        name: "ability", adjacencyTextureProvider: HighlightType.yellow))
    static let innerAbilityTileSet = TileSet(HighlightTileGroupDefinition(
        name: "inner_ability", adjacencyTextureProvider: HighlightType.innerYellow))
    
    private static let rangeSize = 25
    static let rangeNodes: [SKTileMapNode] = [
        SKTileMapNode(tileSet: MapController.movementTileSet, columns: rangeSize, rows: rangeSize,
                      tileSize: MapController.movementTileSet.defaultTileSize),
        SKTileMapNode(tileSet: MapController.abilityTileSet, columns: rangeSize, rows: rangeSize,
                      tileSize: MapController.abilityTileSet.defaultTileSize),
        SKTileMapNode(tileSet: MapController.innerAbilityTileSet, columns: rangeSize, rows: rangeSize,
                      tileSize: MapController.innerAbilityTileSet.defaultTileSize),]
    
    func setMovementHints(on entity: Entity) {
        let movement = entity.check(.movement)
        let span = movement * 2 + 1
        setHints(on: entity, span: span,
                 tileMap: MapController.rangeNodes[0],
                 tileGroup: MapController.rangeNodes[0].tileSet.tileGroups.first!)
    }

    func setRangeHints(on entity: Entity, ability: Ability) {
        let range = ability.abilityChecker.rangeCheck(entity)
        if range.lowerBound > 1 {
            let innerSpan = range.lowerBound * 2 - 1
            setHints(on: entity, span: innerSpan,
                     tileMap: MapController.rangeNodes[2],
                     tileGroup: MapController.rangeNodes[2].tileSet.tileGroups.first!)
        }
        let span = range.upperBound * 2 + 1
        setHints(on: entity, span: span,
                 tileMap: MapController.rangeNodes[1],
                 tileGroup: MapController.rangeNodes[1].tileSet.tileGroups.first!)
    }
    
    func clearHints(from entity: Entity) {
        gameState.removeChildren(in: MapController.rangeNodes)
        MapController.rangeNodes.forEach { $0.fill(with: nil) }
    }
    
    private func setHints(on entity: Entity, span: Int, tileMap: SKTileMapNode, tileGroup: SKTileGroup) {
        tileMap.enableAutomapping = false
        tileMap.position = entity.mapPosition
        tileMap.isUserInteractionEnabled = false
        tileMap.fillCircle(tileGroup, span: span)
        tileMap.alpha = 0.5
        gameState.addChild(tileMap)
    }
    
    func addAttackHints(to entity: Entity, ability: Ability) {
        for e in entity.nearbyEntities(within: ability.abilityChecker.rangeCheck(entity)) where e.selectable {
            if let target = ability.checkAvailable(caster: entity, target: e, position: e.position) {
                if let texture = target.texture() {
                    let node = SKSpriteNode(texture: texture)
                    node.isUserInteractionEnabled = false
                    node.position = centerOfTile(e.position.column, e.position.row)
                    gameState.abilityHighlightNodes.append(node)
                    gameState.addChild(node)
                }
            }
        }
    }
    
    func clearAttackHints() {
        gameState.removeChildren(in: gameState.abilityHighlightNodes)
        gameState.abilityHighlightNodes = []
    }
}
