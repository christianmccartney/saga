//
//  MovementAbilityAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/19/21.
//

import SpriteKit

let dashAnimation: AbilityAnimation = { caster, target, position, closure in
    let mapController = MapController.shared
    let casterPosition = caster.mapPosition
    let direction: CGPoint
    if let target = target {
        direction = mapController.centerOfTile(target.position.column, target.position.row)
    } else {
        direction = mapController.centerOfTile(position.column, position.row)
    }
    let bopAction = SKAction.move(by: CGVector(dx: (direction.x - casterPosition.x)/2,
                                               dy: (direction.y - casterPosition.y)/2),
                                  duration: 0.125)
    let reverseAction = bopAction.reversed()
    let bopGroup = SKAction.sequence([bopAction, reverseAction])
    
    let targetPosition = target?.position ?? position
    
    caster.move(to: targetPosition) {
//        caster.spriteNode.run(bopGroup) {
            closure()
//        }
    }
}
