//
//  MapController.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

public class MapController {
    static let shared = MapController(tileSet: CryptDefinition.stoneTileSet,
                                      mapGenerator: CryptDefinition.dungeonGenerator)
    var graph: GKGridGraph<GKGridGraphNode>!
    weak var gameState: GameState!
    
    var map: SKTileMapNode
    var tileSet: TileSet
    var mapGenerator: MapGenerator
    var roomMap: RoomMap!
    
    private var mapController: MapController { MapController.shared }
    private var inited: Bool = false
    
    private init(tileSet: TileSet, mapGenerator: MapGenerator) {
        self.tileSet = tileSet
        self.mapGenerator = mapGenerator
        self.map = SKTileMapNode(tileSet: tileSet,
                                 columns: mapGenerator.width,
                                 rows: mapGenerator.height,
                                 tileSize: tileSet.defaultTileSize)
    }

    func generateMap() {
        let filledMap = mapGenerator.generate()
        self.roomMap = filledMap.roomMap
        
        for x in 0..<map.numberOfColumns {
            for y in 0..<map.numberOfRows {
                let gridPosition = map.mapGridPosition(for: Position(x, y), with: filledMap.roomMap)
                if let tileGroup = tileSet.mapTileDefinition(for: gridPosition) {
                    map.setTileGroup(tileGroup, forColumn: x, row: y)
                }
//                if gridPosition != 0, let node = graph.node(atGridPosition: vector_int2(Int32(x), Int32(y))) {
//                    walls.append(node)
//                }
            }
        }
        
        for entity in filledMap.entities {
            mapController.addChild(entity)
//            entity.updatePosition()
        }
        
        if !inited {
            gameState.addChild(map)
            inited = true
        }
    }
    
    func generateMap(tileSet: TileSet, mapGenerator: MapGenerator) {
        self.tileSet = tileSet
        self.mapGenerator = mapGenerator
        generateMap()
    }
    
}

// MARK: Accessing map properties
extension MapController {
    func centerOfTile(_ x: Int, _ y: Int) -> CGPoint { map.centerOfTile(atColumn: x, row: y) }
    func tileColumnIndex(_ position: CGPoint) -> Int { map.tileColumnIndex(fromPosition: position) }
    func tileRowIndex(_ position: CGPoint) -> Int { map.tileRowIndex(fromPosition: position) }
    
    func fill() {
        map.fill(with: nil)
    }
}

// MARK: Adding and removing
extension MapController {
    func addAbilityNodes(_ node: SKSpriteNode) {
        gameState.abilityHighlightNodes.append(node)
        map.addChild(node)
    }
    
    func removeAbilityNodes() {
        map.removeChildren(in: gameState.abilityHighlightNodes)
        gameState.abilityHighlightNodes = []
    }

    func addChild(_ entity: Entity) {
        map.addChild(entity.spriteNode)
        gameState.addChild(entity)
    }

    func addChildren( _ entities: [Entity]) {
        for entity in entities {
            addChild(entity)
        }
    }
    
    func removeChild(_ entity: Entity) {
        map.removeChildren(in: [entity.spriteNode])
        gameState.removeChild(entity)
    }
    
    func removeChildren(_ entities: [Entity]) {
        for entity in entities {
            removeChild(entity)
        }
    }

    func addChild(_ emitter: Emitter) {
        for child in emitter.emitters {
            map.addChild(child)
        }
    }

    func removeChild(_ emitter: Emitter) {
        map.removeChildren(in: emitter.emitters)
    }
    
    func addChild(_ node: SKNode) {
        map.addChild(node)
    }
    
    func removeChildren(in nodes: [SKNode]) {
        map.removeChildren(in: nodes)
    }
}
