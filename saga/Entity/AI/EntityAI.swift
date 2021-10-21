//
//  EntityAI.swift
//  saga
//
//  Created by Christian McCartney on 10/21/21.
//

import GameplayKit

open class EntityActionInceptor {
    weak var entity: Entity!
    public init() {}

    func interpretSurroundings() -> Entity? { return nil }
    
    func createAction() -> Position? { return nil }
}

class PlayerEntityActionInceptor: EntityActionInceptor {
    override func interpretSurroundings() -> Entity? {
        return nil
    }
    
    override func createAction() -> Position? {
        return nil
    }
}

class NeutralEntityActionInceptor: EntityActionInceptor {
    override func interpretSurroundings() -> Entity? {
        let nearbyEntities = entity.nearbyEntities
        var closestEnemy: Entity?
        var distance = Int.max
        for nearbyEntity in nearbyEntities {
            let entityDistance = nearbyEntity.position.distance(entity.position)
            if entityDistance < distance {
                closestEnemy = nearbyEntity
                distance = entityDistance
            }
//            if nearbyEntity.faction.isHostileTo(entity.faction) {
//                closestEnemy = nearbyEntity
//            }
        }
        return closestEnemy
    }
    
    override func createAction() -> Position? {
        if let closestEnemy = interpretSurroundings(), let map = entity.map {
            let startPos = vector_int2(Int32(entity.position.column), Int32(entity.position.row))
            let endPos = vector_int2(Int32(closestEnemy.position.column), Int32(closestEnemy.position.row))
            if let startNode = map.graph.node(atGridPosition: startPos),
               let endNode = map.graph.node(atGridPosition: endPos) {
                let path = map.graph.findPath(from: startNode, to: endNode)
                if let firstNode = path.dropFirst().first as? GKGridGraphNode {
                    return Position(Int(firstNode.gridPosition.x), Int(firstNode.gridPosition.y))
                }
                print("\(path)")
            }
        }
        return nil
    }
}