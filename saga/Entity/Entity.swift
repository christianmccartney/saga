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
    public var actionInceptor: EntityActionInceptor

    var type: EntityType

    var direction: EntityDirection
    var faction: EntityFaction
    var statistics: Statistics

    var position: Position
//    {
//        didSet {
//            if let map = map {
//                spriteNode.position = map.centerOfTile(atColumn: position.column, row: position.row)
//            }
//        }
//    }
    
    var scale: CGFloat {
        get { spriteNode.xScale }
        set { spriteNode.setScale(newValue) }
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
        self.actionInceptor = EntityActionInceptor()
        super.init()
        actionInceptor.entity = self
        spriteNode.nodeDelegate = self
    }

    deinit {
        System.shared.removeEntity(self)
    }

    func addComponents(_ components: [Component]) {
        components.forEach { addComponent($0.copy()) }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func copy() -> Entity {
        let entity = Entity(id: UUID(), spriteNode: spriteNode.copy(), type: type, position: position, direction: direction, faction: faction, statistics: statistics, idleFrames: idleFrames, entityDelegate: entityDelegate)
        entity.addComponents(components.compactMap { $0 as? Component })
        System.shared.addEntity(entity)
        return entity
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

    private func angle(to: simd_float2) -> Float {
        let from = direction.directionVector
        let dot = dot(from, to)
        return acos(dot)
    }

    private func direction(to newLocation: CGPoint) -> simd_float2 {
        let spriteNodePosition = simd_float2(Float(spriteNode.position.x), Float(spriteNode.position.y))
        let newLocationVector = simd_float2(Float(newLocation.x), Float(newLocation.y))
        let direction = normalize(newLocationVector - spriteNodePosition)
        return direction
    }
    
    private func rotation(to newLocation: CGPoint) -> EntityDirection? {
        let direction = direction(to: newLocation)
        if let entityDirection = EntityDirection.fromDirection(direction) {
            return entityDirection
        }
        let angle = angle(to: direction)
        if angle > Float.pi/2 {
            return EntityDirection(rawValue: (self.direction.rawValue + 2) % 4)
        }
        return nil
    }

    func move(to location: CGPoint, from scene: SKScene, _ callback: @escaping (() -> ())) {
        if let mapNode = map {
            let pos = scene.convert(location, to: mapNode)
            let column = mapNode.tileColumnIndex(fromPosition: pos)
            let row = mapNode.tileRowIndex(fromPosition: pos)
            let center = mapNode.centerOfTile(atColumn: column, row: row)
            if let newDirection = rotation(to: center) {
                direction = newDirection
            }
            let action = SKAction.move(to: center, duration: 0.25)
            position = Position(column, row)
            spriteNode.run(action, completion: callback)
        }
    }

    func move(to position: Position, _ callback: @escaping (() -> ())) {
        if let mapNode = map {
            let location = mapNode.centerOfTile(atColumn: position.column, row: position.row)
            if let newDirection = rotation(to: location) {
                direction = newDirection
            }
            let action = SKAction.move(to: location, duration: 0.25)
            self.position = position
            spriteNode.run(action, completion: callback)
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
        return statistics.checkStat(statistic)
    }

    var isUserInteractionEnabled: Bool {
        get {
            spriteNode.isUserInteractionEnabled
        }
        set {
            spriteNode.isUserInteractionEnabled = newValue
        }
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

    var nearbyEntities: [Entity] {
        entityDelegate?.nearbyEntities(to: self) ?? []
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

extension Entity {
    open override var description: String {
        return "\(name)\n------------------\n\(statistics.description)"
    }
}
