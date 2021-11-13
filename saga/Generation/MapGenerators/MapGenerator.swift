//
//  MapGenerator.swift
//  saga
//
//  Created by Christian McCartney on 10/14/21.
//

import Foundation

enum MapType {
    //case dungeon
    case cave
}

public typealias RoomMap = [[Bool]]

open class MapGenerator {
    let width: Int
    let height: Int
    var maps: [RoomMap] = []

    public init(width: Int, height: Int) {
        self.height = height
        self.width = width
    }

    open func initializeMap(map: inout RoomMap) {}

    open func generate() -> RoomMap {
        var map: RoomMap = Array(repeating: Array(repeating: true, count: width), count: height)
        for x in 0..<width {
            map[0][x] = false
            map[1][x] = false
            map[height-1][x] = false
            map[height-2][x] = false
        }
        for y in 0..<height {
            map[y][0] = false
            map[y][1] = false
            map[y][width-1] = false
            map[y][width-2] = false
        }
        return map
    }

    func visualize(_ room: RoomMap) {
        var rowCount = 0
        for x in room.reversed() {
            print("[ ", terminator: "")
            for y in x {
                print("\(y ? 1 : 0) ", terminator: "")
            }
            print(" ] \(rowCount)")
            rowCount += 1
        }
    }
}
