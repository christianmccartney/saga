//
//  Room.swift
//  saga
//
//  Created by Christian McCartney on 10/14/21.
//

import Foundation
import CoreGraphics

public struct RectangularRoom {
    let x1: Int
    let x2: Int
    let y1: Int
    let y2: Int

    public init(x1: Int, x2: Int, y1: Int, y2: Int) {
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    }

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.x1 = x
        self.x2 = x + width
        self.y1 = y
        self.y2 = y + height
    }

    var center: CGPoint {
        return CGPoint(x: (x1 + x2)/2, y: (y1 + y2)/2)
    }

    var width: Int {
        return abs(x1 - x2)
    }
    
    var height: Int {
        return abs(y1 - y2)
    }

    func intersects(_ room: RectangularRoom) -> Bool {
        return x1 <= room.x2 && x2 >= room.x1 && y1 <= room.y2 && room.y2 >= room.y1
    }
}
