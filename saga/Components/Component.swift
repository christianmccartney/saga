//
//  Component.swift
//  saga
//
//  Created by Christian McCartney on 10/10/21.
//

import SpriteKit
import GameplayKit

open class Component: GKComponent {
    var _entity: Entity {
        guard let e = entity as? Entity else { fatalError("Could not cast as Entity") }
        return e
    }
}
