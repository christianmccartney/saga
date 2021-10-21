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

    func nearbyEntities(to entity: Entity) -> [Entity]
}

extension Entity: NodeDelegate {}

extension Entity: Selectable {
    var entityDescription: String {
        var description = name + "\n"
        description.append("<----------------->\n")
        for statistic in statistics {
            description.append("\(statistic.statisticType) : \(statistic.value)\n")
        }
        return description
    }
}
