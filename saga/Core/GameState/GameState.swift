//
//  GameState.swift
//  saga
//
//  Created by Christian McCartney on 10/21/21.
//

import SpriteKit
import Combine

// What I want:
// 1. Feed touch event in
// 2. State mutates
// 3. Things update
// 4. Ready to accept new state

open class GameState: InputManager, StateMachine {
    var cameraNode: Camera!
    var interface: Interface = Interface.shared
    var mapSet: MapSet?
    var entities = Set<Entity>()

    public private(set) var acting: Bool = false

    // MARK: - Game State
    
    var sortedEntities: [Entity] {
        get {
            entities.compactMap { $0 as? Creature }.sorted { $0.statistics.checkStat(.initiative) > $1.statistics.checkStat(.initiative) }
        }
    }

    var inCombat: Bool = false

    // take snapshot of the order of entities
    private var currentCombatOrder: [Entity] = []
    // remember which one is acting next
    private var currentCombatIndex: Int = 0
    // remember the number of entities we had in case some new ones get added (necessary?)
    private var currentCombatCount: Int = 0

    var activeEntity: Entity? = nil
    @Published var playerEntity: Entity? = nil

    private func updateActiveEntity() {
        guard currentCombatIndex < currentCombatOrder.count else {
            Selection.shared.activeEntity = nil
            activeEntity = nil
            return
        }
        let activeEntity = currentCombatOrder[currentCombatIndex]
        Selection.shared.activeEntity = activeEntity
        Selection.shared.highlight(activeEntity, set: true)
        self.activeEntity = activeEntity
    }

    func beginCombat() {
        inCombat = true
        currentCombatOrder = sortedEntities
        currentCombatCount = currentCombatOrder.count
        updateActiveEntity()
        focusOnActive()
    }

    // This is not how it should work
    private func recalculateCombatOrder() {
        currentCombatOrder = sortedEntities
        currentCombatCount = currentCombatOrder.count
        updateActiveEntity()
    }

    func removeFromCombat(_ entity: Entity) {
        entities.remove(entity)
        recalculateCombatOrder()
    }
    
    public func offerTurn(_ closure: @escaping (Bool) -> Void) {
        if let activeEntity = activeEntity, activeEntity.faction != .player {
            acting = true
            // do an ai here
            if let position = activeEntity.actionInceptor.createAction() {
                aiInput(position, .move) { success in
                    if success {
                        self.advanceTurn()
                        closure(true)
                        return
                    } else {
                        self.acting = false
                    }
                }
            } else {
                aiInput(nil) { success in
                    if success {
                        self.advanceTurn()
                        closure(true)
                        return
                    } else {
                        self.acting = false
                    }
                }
            }
        }
    }

    public func offerTurn(_ position: CGPoint, _ entity: Entity?) {
        if let activeEntity = activeEntity, activeEntity.faction == .player {
            input(position, entity) { success in
                if success {
                    self.advanceTurn()
                } else {
                    self.acting = false
                }
            }
        }
    }
    
    private func input(_ position: CGPoint, _ entity: Entity?, _ closure: @escaping (Bool) -> ()) {
        guard !acting else {
            closure(false)
            return
        }
        if inCombat {
            if Selection.shared.highlightedEntity == nil, let entity = entity {
                Selection.shared.highlight(entity)
                closure(false)
                return
            }
            
            // touched an entity, highlight it
            if let entity = entity {
                // have a selected ability, try to do it on the selected entity
                if let activeEntity = activeEntity,
                   Selection.shared.highlightedEntity == activeEntity,
                   let ability = activeEntity.selectedAbility {
                    acting = true
                    ability.act(from: activeEntity, on: entity, position: entity.position) { success in
                        if success {
                            Selection.shared.highlight(nil)
                            closure(true)
                        } else {
                            closure(false)
                        }
                    }
                    return
                }

                // if we couldnt act on self, but we selected self, then deselect self
                if entity == Selection.shared.highlightedEntity {
                    Selection.shared.highlight(nil)
                    closure(false)
                    return
                }
                
                // otherwise the selected entity was out of range of the selected ability, so select that entity
                Selection.shared.highlight(entity)
                closure(false)
                return
            } else { // touched an empty square
    
                // if theres an active entity but it isnt the selected entity, dont do an action
                if let activeEntity = activeEntity, Selection.shared.highlightedEntity != activeEntity {
                    closure(false)
                    return
                }
                
                if let activeEntity = activeEntity, let map = mapSet?.currentMap, let scene = scene {
                    let movement = activeEntity.check(.movement)
                    let touchPosition = Position(map.tileColumnIndex(fromPosition: position),
                                                 map.tileRowIndex(fromPosition: position))
                    // gonna do an action
                    if Selection.shared.highlightedEntity == activeEntity,
                       let ability = activeEntity.selectedAbility {
                        acting = true
                        ability.act(from: activeEntity, on: nil, position: touchPosition) { success in
                            if success {
                                Selection.shared.highlight(nil)
                                closure(true)
                            } else {
                                closure(false)
                            }
                        }
                        return
                    }
                    
                    // no selected ability, move instead
                    if activeEntity.position.distance(touchPosition) <= movement {
                        acting = true
                        activeEntity.move(to: position, from: scene) {
                            Selection.shared.highlight(nil)
                            closure(true)
                        }
                        return
                    }
                }
            }
        }
        closure(false)
    }

    private func aiInput(_ position: Position?, _ action: EntityAction = .none, _ closure: @escaping (Bool) -> ()) {
        switch action {
        case .none:
            let action = SKAction.wait(forDuration: 0.25)
            activeEntity?.spriteNode.run(action) {
                closure(true)
            }
            return
        case .move:
            if let position = position, let entity = activeEntity, let map = entity.map {
                guard map.roomMap[position.row][position.column] else { return }
                let location = map.centerOfTile(atColumn: position.column, row: position.row)
                if let newDirection = entity.rotation(to: location) {
                    entity.direction = newDirection
                }
                let action = SKAction.move(to: location, duration: 0.25)
                entity.position = position
                entity.spriteNode.run(action) {
                    closure(true)
                }
                return
            }
        case .attack:
            break
        case .cast:
            break
        case .defend:
            break
        }
        closure(false)
    }

    public func advanceTurn() {
        acting = false
        currentCombatIndex = (currentCombatIndex + 1) % currentCombatOrder.count
        updateActiveEntity()
//        if let activeEntity = activeEntity, activeEntity.faction != .player {
//            // do an ai here
//            if let position = activeEntity.actionInceptor.createAction() {
//                aiInput(position, .move)
//            } else {
//                aiInput(nil)
//            }
//            // activeEntity.offerTurn()
//        }
    }

    // MARK: --------------------

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
        if inCombat { recalculateCombatOrder() }
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
}
