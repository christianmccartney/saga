//
//  TestMap.swift
//  Saga
//
//  Created by Christian McCartney on 5/19/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

/// A `Map` is one SKTileMapNode contained in an .sks file.
open class Map: SKTileMapNode {
    var graph: GKGridGraph<GKGridGraphNode>!

    var entities = Set<Entity>()
    var objects: [Object] = []
    var warpTiles: [WarpTile] = []
    var roomMap: RoomMap
    var movementHintNodes = [Node]()
    var abilityHintNodes = [Node]()

    public init(tileSet: SKTileSet, columns: Int, rows: Int, room: RoomMap) {
        self.roomMap = room
        super.init(tileSet: tileSet,
                   columns: columns,
                   rows: rows,
                   tileSize: tileSet.defaultTileSize)
        enableAutomapping = false
        for x in 0..<columns {
            for y in 0..<rows {
                let gridPosition = mapGridPosition(for: Position(x, y), with: room)
                if let tileGroup = tileSet.mapTileDefinition(for: gridPosition) {
                    setTileGroup(tileGroup, forColumn: x, row: y)
                }
            }
        }
        self.graph = buildGraph()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildGraph() -> GKGridGraph<GKGridGraphNode> {
        let graph = GKGridGraph(
            fromGridStartingAt: vector2(0, 0),
            width: Int32(numberOfColumns),
            height: Int32(numberOfRows),
            diagonalsAllowed: true)
        var walls: [GKGridGraphNode] = []
        for x in 0..<numberOfRows {
            for y in 0..<numberOfColumns {
                if !roomMap[y][x], let node = graph.node(atGridPosition: vector_int2(Int32(x), Int32(y))) {
                    walls.append(node)
                }
            }
        }
        graph.remove(walls)
        return graph
    }

    func getGraphNode(_ position: Position) -> GKGraphNode? {
        return graph.node(atGridPosition: vector_int2(x: Int32(position.column), y: Int32(position.row)))
    }

    func findChild(_ node: SKNode) -> Entity? {
        return entities.first { $0.spriteNode == node }
    }

    func addChild(_ entity: Entity) {
        entities.insert(entity)
        entity.map = self
        addChild(entity.spriteNode)
    }

    func removeChild(_ entity: Entity) {
        entities.remove(entity)
        entity.map = nil
        removeChildren(in: [entity.spriteNode])
    }

//    func removeChild(_ entities: [Entity]) {
//        self.entities = self.entities.filter { !entities.contains($0) }\
//        entities.removeChildren(from: mapNode)
//    }

//    func getNearbyEntities(to entity: Entity) -> Set<Entity> {
//        var nearbyEntities = Set<Entity>()
//        for e in entities {
//            if entity.isNearby(e) {
//                nearbyEntities.insert(e)
//            }
//        }
//        return nearbyEntities
//    }

    func updatePositions() {
        for entity in entities {
            entity.updatePosition()
        }

        for object in objects {
            object.updatePosition()
        }
    }

    func updateGridGraph() {
        var objectNodes: [GKGraphNode] = []
        for object in objects {
            if let graphNode = graph.node(atGridPosition: vector_int2(x: Int32(object.position.column), y: Int32(object.position.row))) {
                objectNodes.append(graphNode)
            }
        }

        graph.remove(objectNodes)
    }
}
