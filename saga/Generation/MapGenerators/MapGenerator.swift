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

public struct FilledMap {
    let roomMap: RoomMap
    let entities: [Entity]
}

open class MapGenerator {
    let width: Int
    let height: Int
    var maps: [RoomMap] = []
    var objectPlacer: ObjectPlacer

    public init(width: Int, height: Int, objectPlacer: ObjectPlacer = ObjectPlacer()) {
        self.height = height
        self.width = width
        self.objectPlacer = objectPlacer
    }

    open func initializeMap(map: inout RoomMap) {}

    open func generate() -> FilledMap {
        var map: RoomMap = Array(repeating: Array(repeating: false, count: width), count: height)
//        for x in 0..<width {
//            map[0][x] = false
//            map[1][x] = false
//            map[height-1][x] = false
//            map[height-2][x] = false
//        }
//        for y in 0..<height {
//            map[y][0] = false
//            map[y][1] = false
//            map[y][width-1] = false
//            map[y][width-2] = false
//        }
        let hallways = [RectangularRoom(x: 7, y: 5, width: 3, height: 1), // hall
                        RectangularRoom(x: 15, y: 5, width: 3, height: 1), // hall
                        RectangularRoom(x: 24, y: 5, width: 3, height: 1), // hall
                        RectangularRoom(x: 20, y: 9, width: 2, height: 6), // hall
                        ]
        
        let rooms = [RectangularRoom(x: 3, y: 3, width: 4, height: 4),
                     RectangularRoom(x: 10, y: 3, width: 5, height: 5),
                     RectangularRoom(x: 18, y: 3, width: 6, height: 6),
                     RectangularRoom(x: 27, y: 3, width: 7, height: 7),
                     RectangularRoom(x: 3, y: 15, width: 8, height: 8),
                     RectangularRoom(x: 14, y: 15, width: 9, height: 9),
                     RectangularRoom(x: 26, y: 15, width: 10, height: 10),
                    ]
        var entities = [Entity]()
        
        hallways.forEach { $0.addRoom(to: &map) }
        rooms.forEach { entities.append(contentsOf: objectPlacer.entities(room: $0, map: &map)) }
        rooms.forEach { $0.addRoom(to: &map) }
        
        return FilledMap(roomMap: map, entities: entities)
    }
    
    open func createRooms() {
        print("Override this")
    }
}
