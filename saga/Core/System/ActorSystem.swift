//
//  ActorSystem.swift
//  saga
//
//  Created by Christian McCartney on 11/15/21.
//

import GameplayKit

// This is a crucial system to time updates, animations, and turns
final class ActorSystem: GKComponentSystem<GKComponent> {
    static let shared = ActorSystem(componentClass: ActorComponent.self)
    weak var gameState: GameState!

    private var turnTime: TimeInterval = 0
    private let minTurnTime: TimeInterval = 1.0
    private let maxTurnTime: TimeInterval = 0.5

    private var deathQueue = [(DeathAnimation, Entity)]()
    private var updating = false
    
    func enqueueAction(_ deathAnimation: @escaping DeathAnimation, _ entity: Entity) {
        gameState.removeFromCombat(entity)
        deathQueue.append((deathAnimation, entity))
    }

    private func executeActions() {
        for (deathAnimation, entity) in deathQueue {
            deathAnimation(entity)
        }
        updating = false
        deathQueue = []
    }

    override func update(deltaTime seconds: TimeInterval) {
        turnTime += seconds
        
        if !deathQueue.isEmpty {
            updating = true
            executeActions()
        }

        if turnTime >= minTurnTime, !gameState.acting, !updating, deathQueue.isEmpty {
            gameState?.offerTurn { _ in
                self.updating = false
            }
        }
    }
}
