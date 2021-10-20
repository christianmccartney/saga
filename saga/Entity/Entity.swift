//
//  Entity.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

public typealias HostilityClosure = ((EntityFaction, EntityFaction) -> Bool)

open class Entity: GKEntity {
    let id: UUID
    var spriteNode: Node
    //var graphNode: GKGraphNode

    weak var map: Map?
    public weak var entityDelegate: EntityDelegate?

    var type: EntityType

    var direction: EntityDirection
    var faction: EntityFaction
    var statistics: Statistics

    var position: Position {
        didSet {
            if let map = map {
                spriteNode.position = map.centerOfTile(atColumn: position.column, row: position.row)
            }
        }
    }

    var idleFrames: [EntityDirection: [SKTexture]] = [:]
    var graphNodePath: [GKGridGraphNode] = []
    var queuedMoves: SKAction?
    var lastNode: GKGridGraphNode?

    private var children = Set<Entity>()

    public static let defaultHostilityClosure: HostilityClosure = { _, _ in return false }

    public init(id: UUID,
                spriteNode: Node,
                type: EntityType,
                position: Position,
                direction: EntityDirection = .down,
                faction: EntityFaction,
                statistics: Statistics = Statistics(),
                idleFrames: [EntityDirection: [SKTexture]] = [:],
                entityDelegate: EntityDelegate? = nil) {
        self.id = id
        self.spriteNode = spriteNode
        self.type = type
        self.position = position
        self.direction = direction
        self.faction = faction
        self.statistics = statistics
        self.idleFrames = idleFrames
        self.entityDelegate = entityDelegate
        super.init()
        spriteNode.nodeDelegate = self
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var name: String {  "\(type)" }

    func updatePosition() {
        if let map = map {
            spriteNode.position = map.centerOfTile(atColumn: position.column, row: position.row)
        }
    }

    var mapPosition: CGPoint? { map?.centerOfTile(atColumn: position.column, row: position.row) }

    func addChild(_ entity: Entity) {
        children.insert(entity)
        spriteNode.addChild(entity.spriteNode)
    }

    func removeChild(_ entity: Entity) {
        children.remove(entity)
        spriteNode.removeChildren(in: [entity.spriteNode])
    }

    func move(to location: CGPoint, from scene: SKScene) {
        if let mapNode = map {
            let pos = scene.convert(location, to: mapNode)
            let column = mapNode.tileColumnIndex(fromPosition: pos)
            let row = mapNode.tileRowIndex(fromPosition: pos)
            position = Position(column, row)
        }
    }

    func getGraphNode() -> GKGraphNode? {
        return map?.graph.node(atGridPosition: vector_int2(x: Int32(position.column), y: Int32(position.row)))
    }

    func createMoveActions() {
        guard let map = map else { return }

        var actions: [SKAction] = []
        var previousPosition = position
        var lastDirection: EntityDirection = direction
        for graphNode in graphNodePath {
            let position = graphNode.gridPosition
            let mapPosition = map.centerOfTile(atColumn: Int(position.x), row: Int(position.y))
            let newPosition = Position(position)

            //actions.append(SKAction.run {
            let newDirection = direction.getNewDirection(previousPosition, newPosition, lastDirection)
            let newTexture = getDirectionTexture(newDirection)
            //})
            actions.append(SKAction.setTexture(newTexture))
            actions.append(SKAction.move(to: mapPosition, duration: 0.5))

            previousPosition = newPosition
            lastDirection = newDirection
        }
        lastNode = graphNodePath.last

        graphNodePath = []
        queuedMoves = SKAction.sequence(actions)
    }

    func getDirectionTexture(_ direction: EntityDirection) -> SKTexture {
        guard let texture = idleFrames[direction]?.first else {
            fatalError("Could not find texture in " + String(describing: direction))
        }
        return texture
    }

    func check(_ statistic: StatisticType) -> Int {
        return 0
    }

    func checkCombatStatus() -> Bool {
        //let nearbyEntities = map?.getNearbyEntities(to: self)
        return true
        //return nearbyEntities?.contains { $0.faction.isHostileTo(self.type) } ?? false
    }

    func isNearby(_ entity: Entity) -> Bool {
        if entity.id == self.id { return false }

        guard let position1 = lastNode?.gridPosition,
            let position2 = lastNode?.gridPosition else { return false }

        return sqrt(pow(Double(position2.x - position1.x), 2) + pow(Double(position2.y - position1.y), 2)) < 5
    }

    func move() {
        spriteNode.removeAction(forKey: "idle")
        if let moves = queuedMoves {
            spriteNode.run(moves)
        }
        if let lastNode = lastNode {
            position = Position(lastNode.gridPosition)
        }
        queuedMoves = nil
    }

    public func touchDown(_ pos: CGPoint) {
        entityDelegate?.touchDown(pos, entity: self)
    }
    
    public func touchMoved(_ pos: CGPoint) {
        entityDelegate?.touchMoved(pos, entity: self)
    }
    
    public func touchUp(_ pos: CGPoint) {
        entityDelegate?.touchUp(pos, entity: self)
    }
}

// MARK: Helper Functions

extension Array where Element == Entity {
    func removeChildren(from scene: SKNode) {
        var nodes: [SKNode] = []
        for entity in self {
            entity.map = nil
            nodes.append(entity.spriteNode)
        }
        scene.removeChildren(in: nodes)
    }
}
