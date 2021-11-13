//
//  EntityDelegate.swift
//  saga
//
//  Created by Christian McCartney on 10/21/21.
//

import CoreGraphics

extension GameState: EntityDelegate {
    public func touchDown(_ pos: CGPoint, entity: Entity? = nil) {
        input(pos, entity)
        //print("touch down \(pos) : \(entity?.type)")
    }
    
    public func touchMoved(_ pos: CGPoint, entity: Entity? = nil) {
        //print("touch moved \(pos) : \(entity?.type)")
    }
    
    public func touchUp(_ pos: CGPoint, entity: Entity? = nil) {
        //print("touch up \(pos) : \(entity?.type)")
    }

    public func nearbyEntities(to entity: Entity, within range: ClosedRange<Int>) -> [Entity] {
        var nearbyEntities = [Entity]()
        for e in entities {
            if entity != e {
                if entity.position.distance(e.position) < range.upperBound {
                    nearbyEntities.append(e)
                }
            }
        }
        return nearbyEntities
    }
}
