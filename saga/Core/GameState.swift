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
    func addChild(_ entities: [Entity])

    func addMap(_ map: Map)
    func addMapSet(_ mapSet: MapSet)

    // Camera
    func focusOnActive()

    // Entity manipulation
    var activeEntity: Entity? { get }
    var _entities: [Entity] { get }

    func updatePositions()
}

extension CoreScene: GameState {
    func pause(_ pause: Bool) {
        isPaused = pause
        mapSet?.currentMap?.isPaused = pause
        for entity in _entities {
            entity.spriteNode.isPaused = pause
        }
    }
    // MARK: - Adding/Removing things
    func addChild(_ entity: Entity) {
        entities.append(entity)
        mapSet?.currentMap?.addChild(entity)
    }

    func addChild(_ entities: [Entity]) {
        for entity in entities {
            entity.entityDelegate = self
            addChild(entity)
        }
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
            if let e = entity as? Entity {
                e.updatePosition()
            }
        }
    }

    var activeEntity: Entity? {
        get {
            for entity in entities {
                if let e = entity as? Entity, e.faction == .player {
                    return e
                }
            }
            return nil
        }
    }

    var _entities: [Entity] {
        get { entities.compactMap { $0 as? Entity } }
    }
}
