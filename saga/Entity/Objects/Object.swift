//
//  Object.swift
//  Saga
//
//  Created by Christian McCartney on 5/25/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

/// A `Object` is any item in a map that can either be interacted with or not.
//protocol Object: GKEntity {
//
//    /// Uniquely identify objects.
//    var id: UUID { get }
//
//    /// The `Map` that this object belongs to, should be weak probably.
//    var map: Map? { get set }
//
//    /// The sprite node that represents this object in the scene.
//    var spriteNode: SKSpriteNode { get set }
//
//    /// The position on the graph of this object.
//    var position: Position { get set }
//
//    func updatePosition()
//}

open class Object: Entity {}

// MARK: Helper Functions

//extension Array where Element == Object {
//    func isElementOf(_ element: Object) -> Bool {
//        for object in self {
//            if object.id == element.id {
//                return true
//            }
//        }
//        return false
//    }
//
//    func removeChildren(from scene: SKNode) {
//        var nodes: [SKNode] = []
//        for object in self {
//            object.map = nil
//            nodes.append(object.spriteNode)
//        }
//        scene.removeChildren(in: nodes)
//    }
//}
