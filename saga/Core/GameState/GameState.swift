//
//  GameState.swift
//  saga
//
//  Created by Christian McCartney on 10/10/21.
//

import SpriteKit
import GameplayKit

protocol GameState {
    func pause(_ pause: Bool)
    // Adding/Removing things
    var mapSet: MapSet? { get set }
    
    func addChild(_ entity: Entity)
    func addChildren(_ entities: [Entity])

    func removeChild(_ entity: Entity)
    func removeChildren(_ entities: [Entity])

    // when an entity needs to be added to the gameloop but not the map
    func track(_ entity: Entity)
    func untrack(_ entity: Entity)

    func addMap(_ map: Map)
    func addMapSet(_ mapSet: MapSet)

    // Camera
    func focusOnActive()

    // Entity manipulation
    var activeEntity: Entity? { get }

    func updatePositions()

    // Game State
    var sortedEntities: [Entity] { get }
    var inCombat: Bool { get set }
    func beginCombat()
}

extension CoreScene: GameState {
    func pause(_ pause: Bool) {
        isPaused = pause
        mapSet?.currentMap?.isPaused = pause
        for entity in entities {
            entity.spriteNode.isPaused = pause
        }
    }
    // MARK: - Adding/Removing things
    func addChild(_ entity: Entity) {
        entities.insert(entity)
        mapSet?.currentMap?.addChild(entity)
    }

    func addChildren(_ entities: [Entity]) {
        for entity in entities {
            entity.entityDelegate = self
            addChild(entity)
        }
    }
    
    func removeChild(_ entity: Entity) {
        entities.remove(entity)
        mapSet?.currentMap?.removeChild(entity)
    }
    
    func removeChildren(_ entities: [Entity]) {
        for entity in entities {
            removeChild(entity)
        }
    }

    func track(_ entity: Entity) {
        entities.insert(entity)
    }

    func untrack(_ entity: Entity) {
        entities.remove(entity)
    }

    func addMap(_ map: Map) {
        map.removeFromParent()
        map.setScale(1)
//        map.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(map)
    }
    
    func addMapSet(_ mapSet: MapSet) {
        guard let currentMap = mapSet.currentMap else { return }
        addMap(currentMap)
    }

    // MARK: - Camera
    func focusOnActive() {
        if let mapNode = mapSet?.currentMap, let mapPosition = activeEntity?.mapPosition {
            cameraNode.position = mapNode.convert(mapPosition, to: self)
        }
    }

    // MARK: - Entity manipulation
    func updatePositions() {
        for entity in entities {
            entity.updatePosition()
        }
    }

    var activeEntity: Entity? {
        get {
            for entity in entities {
                if entity.faction == .player {
                    return entity
                }
            }
            return nil
        }
    }

    // MARK: - Game State
    
    var sortedEntities: [Entity] {
        get {
            entities.compactMap { $0 as? Creature }.sorted { $0.statistics.checkStat(.initiative) < $1.statistics.checkStat(.initiative) }
        }
    }

    private static var _inCombat = false
    var inCombat: Bool {
        get { CoreScene._inCombat }
        set { CoreScene._inCombat = newValue }
    }

//    var selectedActionType: EntityAction {
//        get {
//        }
//    }

    // take snapshot of the order of entities
    private static var currentCombatOrder: [Entity] = []
    // remember which one is acting next
    private static var currentCombatIndex: Int = 0
    // remember the number of entities we had in case some new ones get added (necessary?)
    private static var currentCombatCount: Int = 0

    func beginCombat() {
        inCombat = true
        Self.currentCombatOrder = sortedEntities
        Self.currentCombatCount = Self.currentCombatOrder.count
    }
}
