//
//  EntitySelection.swift
//  saga
//
//  Created by Christian McCartney on 10/12/21.
//

import Foundation
import CoreGraphics

public protocol EntityDelegate: AnyObject {
    func touchDown(_ pos: CGPoint, entity: Entity?)
    func touchMoved(_ pos: CGPoint, entity: Entity?)
    func touchUp(_ pos: CGPoint, entity: Entity?)

    func nearbyEntities(to entity: Entity, within range: ClosedRange<Int>) -> [Entity]
}

extension Entity: NodeDelegate {}

