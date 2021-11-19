//
//  Entity.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit
import Combine

enum MoveType {
    case walk
    case push
    case teleport
}

open class Entity: GKEntity, ObservableObject {
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
    var position: Position {
        willSet {
            updatePosition()
        }
    }

    var abilities: [Ability] = []
    @Published var selectedAbility: Ability? {
        didSet {
            if faction == .player {
                DispatchQueue.main.async {
                    if let ability = self.selectedAbility {
                        self.map?.removeHintNodes()
                        self.map?.addAbilityHints(to: self, ability: ability)
                        self.map?.addAttackHints(to: self, ability: ability)
                    } else {
                        self.map?.removeHintNodes()
                        self.map?.removeAttackNodes()
                        self.map?.addMovementHints(to: self)
                    }
                }
            }
        }
    }
    
    var scale: CGFloat {
        get { spriteNode.xScale }
        set { spriteNode.setScale(newValue) }
    }

    var idleFrames: [EntityDirection: [SKTexture]] = [:]
    private var children = Set<Entity>()
    
    private var cancellables = Set<AnyCancellable>()
    
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
        spriteNode.entity = self
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
    
    @MainActor
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
        DispatchQueue.main.async {
            self.spriteNode.addChild(entity.spriteNode)
        }
    }
    
    func removeChild(_ entity: Entity) {
        children.remove(entity)
        DispatchQueue.main.async {
            self.spriteNode.removeChildren(in: [entity.spriteNode])
        }
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

    func move(to location: CGPoint, from scene: SKScene) async {
        if let map = map {
            let pos = await scene.convert(location, to: map)
            let column = await map.tileColumnIndex(fromPosition: pos)
            let row = await map.tileRowIndex(fromPosition: pos)
            let center = await map.centerOfTile(atColumn: column, row: row)
            guard await map.roomMap[row][column] else { return }
            if let newDirection = rotation(to: center) {
                direction = newDirection
            }
            let action = SKAction.move(to: center, duration: 0.25)
            position = Position(column, row)
            await spriteNode.run(action)
        }
    }

    // TODO 7: Need to distinguish different types of moves, eg. walked pushed teleported etc
    func move(to position: Position) async {
        if let map = map {
            guard await map.roomMap[position.row][position.column] else { return }
            let location = await map.centerOfTile(atColumn: position.column, row: position.row)
            if let newDirection = rotation(to: location) {
                direction = newDirection
            }
            let action = SKAction.move(to: location, duration: 0.25)
            self.position = position
            await spriteNode.run(action)
        }
    }

    func wait() async {
        let action = SKAction.wait(forDuration: 0.25)
        await spriteNode.run(action)
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

    func nearbyEntities(within range: Int) -> [Entity] {
        entityDelegate?.nearbyEntities(to: self, within: 0...range) ?? []
    }

    func nearbyEntities(within range: ClosedRange<Int>) -> [Entity] {
        entityDelegate?.nearbyEntities(to: self, within: range) ?? []
    }

    var nearbyEntities: [Entity] {
        entityDelegate?.nearbyEntities(to: self, within: 0...5) ?? []
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
        return "\(name)"
    }
    
    func inspectorDescription(inspectorWidth: Int) -> String {
        var line: String = ""
        for i in 0..<inspectorWidth-1 {
            line.append("-")
        }
        return "\(name)\n\(line)\(statistics.inspectorDescription)"
    }
}
