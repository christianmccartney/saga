//
//  MovementAbilityAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/19/21.
//

import SpriteKit

let dashAnimation: AbilityAnimation = { caster, target, position, closure in
    guard let map = caster.map, let casterPosition = caster.mapPosition else { return }
    let direction: CGPoint
    if let target = target {
        direction = map.centerOfTile(atColumn: target.position.column, row: target.position.row)
    } else {
        direction = map.centerOfTile(atColumn: position.column, row: position.row)
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
