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
}

extension Entity: NodeDelegate {
    public func touchDown(_ pos: CGPoint) {
        entityDelegate?.touchDown(pos, entity: self)
    }
    
    public func touchMoved(_ pos: CGPoint) {
        entityDelegate?.touchMoved(pos, entity: self)
    }
    
    public func touchUp(_ pos: CGPoint) {
        entityDelegate?.touchUp(pos, entity: self)
    }
}

extension Entity: Selectable {
    var entityDescription: String {
        var description = name + "\n"
        description.append("<----------------->\n")
        for statistic in statistics {
            description.append("\(statistic.statistic) : \(statistic.value)\n")
        }
        return description
    }
}
