//
//  GameState.swift
//  saga
//
//  Created by Christian McCartney on 10/10/21.
//

import SpriteKit
import GameplayKit

protocol StateMachine {
    func pause(_ pause: Bool)
    // Adding/Removing things
    func addChild(_ entity: Entity)
    func addChildren(_ entities: [Entity])
    
    func removeChild(_ entity: Entity)
    func removeChildren(_ entities: [Entity])

    // when an entity needs to be added to the gameloop but not the map
    func track(_ entity: Entity)
    func untrack(_ entity: Entity)

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

//extension GameState: StateMachine {
//}
