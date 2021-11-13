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
    var interface: Interface = Interface()
    var mapSet: MapSet?
    var entities = Set<Entity>()

    private var mutating = false
    
    open override func didMove(to view: SKView) {
        super.didMove(to: view)
    }

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
    
    public func input(_ position: CGPoint, _ entity: Entity?) {
        //guard !mutating else { return }
        if inCombat {
            if Selection.shared.highlightedEntity == nil, let entity = entity {
                Selection.shared.highlight(entity)
                return
            }
            
            // touched an entity, highlight it
            if let entity = entity {
                // gonna do an action
                if let activeEntity = activeEntity,
                   Selection.shared.highlightedEntity == activeEntity,
                   let ability = activeEntity.selectedAbility {
                    if ability.act(from: activeEntity, on: entity, position: entity.position) {
                        advanceTurn()
                    }
                
                    // attack it
                }
                    
                if entity == Selection.shared.highlightedEntity {
                    Selection.shared.highlight(nil)
                    return
                }
                Selection.shared.highlight(entity)
                return
            } else { // touched an empty square
    
                if Selection.shared.highlightedEntity != entity, let entity = entity {
                    Selection.shared.highlight(entity)
                    return
                }
                if let activeEntity = activeEntity, let map = mapSet?.currentMap, let scene = scene {
                    let movement = activeEntity.check(.movement)
                    let touchPosition = Position(map.tileColumnIndex(fromPosition: position),
                                                 map.tileRowIndex(fromPosition: position))
                    // gonna do an action
                    if Selection.shared.highlightedEntity == activeEntity,
                       let ability = activeEntity.selectedAbility {
                        if ability.act(from: activeEntity, on: nil, position: touchPosition) {
                            advanceTurn()
                            return
                        }
                        // attack it
                    }
                    
                    // no selected ability, move instead
                    if activeEntity.position.distance(touchPosition) <= movement {
                        activeEntity.move(to: position, from: scene) {
                            Selection.shared.highlight(nil)
                            self.advanceTurn()
                        }
                    }
                }
            }
        }
    }

    public func aiInput(_ position: Position?, _ action: EntityAction = .none) {
        switch action {
        case .none:
            activeEntity?.wait {
                self.advanceTurn()
            }
            break
        case .move:
            if let position = position {
                activeEntity?.move(to: position) {
                    self.advanceTurn()
                }
            }
        case .attack:
            break
        case .cast:
            break
        case .defend:
            break
        }
    }

    private func advanceTurn() {
        currentCombatIndex = (currentCombatIndex + 1) % currentCombatOrder.count
        updateActiveEntity()
        if let activeEntity = activeEntity, activeEntity.faction != .player {
            // do an ai here
            if let position = activeEntity.actionInceptor.createAction() {
                aiInput(position, .move)
            } else {
                aiInput(nil)
            }
            // activeEntity.offerTurn()
        }
    }

    private func mutate() {
        mutating = true
        
        
        mutating = false
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
