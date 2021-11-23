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

    func contains(_ x: Int, _ y: Int) -> Bool {
        return x > x1 && x < x2 && y > y1 && y < y2
    }

    func nearby(_ x: Int, _ y: Int, _ dx: Int = 1, _ dy: Int = 1) -> Bool {
        for px in x-dy...x+dy {
            for py in x-dy...x+dy {
                if contains(px, py) {
                    return true
                }
            }
        }
        return false
    }

    func addRoom(to roomMap: inout RoomMap) {
        for x in x1..<x2 {
            for y in y1..<y2 {
                roomMap[y][x] = true
            }
        }
    }
}

extension RoomMap {
    // CAREFUL: Maybe gonna run into issues with maps that arent square?
    func nearbyRoom(_ room: RectangularRoom, _ x: Int, _ y: Int, _ dx: Int = 1, _ dy: Int = 1) -> Bool {
        guard x-dx > 0, x+dx < count, y-dy > 0, y+dy < count else { return true }
        for px in x-dx...x+dx {
            for py in y-dy...y+dy {
                if !room.contains(px, py), self[py][px] {
                    return true
                }
            }
        }
        return false
    }
    
    func visualize() {
        var rowCount = 0
        for x in self.reversed() {
            print("[ ", terminator: "")
            for y in x {
                print("\(y ? 1 : 0) ", terminator: "")
            }
            print(" ] \(rowCount)")
            rowCount += 1
        }
    }
}
