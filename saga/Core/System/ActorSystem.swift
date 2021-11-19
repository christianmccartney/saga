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
    private let minTurnTime: TimeInterval = 0.1
    private let maxTurnTime: TimeInterval = 0.5

    private var deathQueue = [(DeathAnimation, Entity)]()
    private var updating = Updating()
    
    actor Updating {
        var state = false
        func update(state: Bool) { self.state = state }
    }
    
    func enqueueAction(_ deathAnimation: @escaping DeathAnimation, _ entity: Entity) {
        deathQueue.append((deathAnimation, entity))
    }

    private func executeActions() {
        for (deathAnimation, entity) in deathQueue {
            deathAnimation(entity)
        }
        deathQueue = []
    }

    override func update(deltaTime seconds: TimeInterval) {
        turnTime += seconds
        
        Task {
            if turnTime >= minTurnTime, await !gameState.acting, await !updating.state {
                await updating.update(state: true)
                executeActions()
                await gameState?.offerTurn()
                await updating.update(state: false)
            }
        }
    }
}
