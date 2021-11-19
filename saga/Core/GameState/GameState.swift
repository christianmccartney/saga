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
        Selection.shared.highlight(activeEntity)
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

    
    public func offerTurn() async {
        if let activeEntity = activeEntity, activeEntity.faction != .player {
            acting = true
            // do an ai here
            if let position = activeEntity.actionInceptor.createAction() {
                if await aiInput(position, .move) {
                    advanceTurn()
                }
            } else {
                if await aiInput(nil) {
                    advanceTurn()
                }
            }
        }
    }

    public func offerTurn(_ position: CGPoint, _ entity: Entity?) async {
        if let activeEntity = activeEntity, activeEntity.faction == .player {
            if await input(position, entity) {
                advanceTurn()
            }
        }
    }
    
    private func input(_ position: CGPoint, _ entity: Entity?) async -> Bool {
        guard !acting else { return false }
        if inCombat {
            if Selection.shared.highlightedEntity == nil, let entity = entity {
                Selection.shared.highlight(entity)
                return false
            }
            
            // touched an entity, highlight it
            if let entity = entity {
                // have a selected ability, try to do it on the selected entity
                if let activeEntity = activeEntity,
                   Selection.shared.highlightedEntity == activeEntity,
                   let ability = activeEntity.selectedAbility {
                    acting = true
                    if await ability.act(from: activeEntity, on: entity, position: entity.position) {
                        Selection.shared.highlight(nil)
                        return true
                    } else {
                        acting = false
                    }
                }

                // if we couldnt act on self, but we selected self, then deselect self
                if entity == Selection.shared.highlightedEntity {
                    Selection.shared.highlight(nil)
                    return false
                }
                
                // otherwise the selected entity was out of range of the selected ability, so select that entity
                Selection.shared.highlight(entity)
                return false
            } else { // touched an empty square
    
                // if theres an active entity but it isnt the selected entity, dont do an action
                if let activeEntity = activeEntity, Selection.shared.highlightedEntity != activeEntity {
                    return false
                }
                
                if let activeEntity = activeEntity, let map = mapSet?.currentMap, let scene = scene {
                    let movement = activeEntity.check(.movement)
                    let touchPosition = Position(map.tileColumnIndex(fromPosition: position),
                                                 map.tileRowIndex(fromPosition: position))
                    // gonna do an action
                    if Selection.shared.highlightedEntity == activeEntity,
                       let ability = activeEntity.selectedAbility {
                        acting = true
                        if await ability.act(from: activeEntity, on: nil, position: touchPosition) {
                            Selection.shared.highlight(nil)
                            return true
                        } else {
                            acting = false
                        }
                    }
                    
                    // no selected ability, move instead
                    if activeEntity.position.distance(touchPosition) <= movement {
                        acting = true
                        await activeEntity.move(to: position, from: scene)
                        Selection.shared.highlight(nil)
                        return true
                    }
                }
            }
        }
        return false
    }

    private func aiInput(_ position: Position?, _ action: EntityAction = .none) async -> Bool {
        switch action {
        case .none:
            await activeEntity?.wait()
            return true
        case .move:
            if let position = position {
                await activeEntity?.move(to: position)
                return true
            }
        case .attack:
            break
        case .cast:
            break
        case .defend:
            break
        }
        return false
    }

    public func advanceTurn() {
        currentCombatIndex = (currentCombatIndex + 1) % currentCombatOrder.count
        updateActiveEntity()
        acting = false
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
