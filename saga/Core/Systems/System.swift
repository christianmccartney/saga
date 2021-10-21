//
//  System.swift
//  saga
//
//  Created by Christian McCartney on 10/20/21.
//

import Foundation
import GameplayKit

// This is annoying but cant subclass GKComponentSystem, I guess there probably wont be too many of these?
public class System {
    static let shared = System()
    private init() {}

    func addEntity(_ entity: Entity) {
        for component in entity.components {
            if component is IdleComponent {
                IdleSystem.shared.addComponent(foundIn: entity)
            }
        }
    }

    func removeEntity(_ entity: Entity) {
        for component in entity.components {
            if component is IdleComponent {
                IdleSystem.shared.removeComponent(foundIn: entity)
            }
        }
    }
}
