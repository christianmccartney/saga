//
//  MaskMapGenerator.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import Foundation

class MaskMapGenerator: MapGenerator {
    let maxRooms: Int
    let minRoomSize: Int
    let maxRoomSize: Int

    public init(width: Int, height: Int, roomDefinitions: [RoomDefinition], maxRooms: Int, minRoomSize: Int = 5, maxRoomSize: Int = 12) {
        self.maxRooms = maxRooms
        self.minRoomSize = minRoomSize
        self.maxRoomSize = maxRoomSize
        super.init(width: width, height: height)
    }

    override func generate() -> FilledMap {
        var map: RoomMap = Array(repeating: Array(repeating: false, count: width), count: height)
        func addRoom(room: RectangularRoom, to roomMap: inout RoomMap) {
            for x in room.x1...room.x2 {
                for y in room.y1...room.y2 {
                    roomMap[y][x] = true
                }
            }
        }
    
        func addHorizontalCorridor(x1: Int, x2: Int, y: Int, roomMap: inout RoomMap) {
            for x in min(x1, x2)...(max(x1, x2) + 1) {
                roomMap[y][x] = true
                roomMap[y+1][x] = true
            }
        }

        func addVerticalCorridor(y1:Int, y2: Int, x: Int, roomMap: inout RoomMap) {
            for y in min(y1, y2)...(max(y1, y2) + 1) {
                roomMap[y][x] = true
                roomMap[y][x+1] = true
            }
        }
            
        var rooms = [RectangularRoom]()
        
        for _ in 0..<maxRooms {
            let w = minRoomSize + Int.random(in: 0..<(maxRoomSize - minRoomSize + 1))
            let h = minRoomSize + Int.random(in: 0..<(maxRoomSize - minRoomSize + 1))
            let x = Int.random(in: 0..<(width - w - 1)) + 1
            let y = Int.random(in: 0..<(height - h - 1)) + 1
            
            let newRoom = RectangularRoom(x1: x, x2: x + w, y1: y, y2: y + h)
            
            let success = rooms.allSatisfy { !$0.intersects(newRoom) }
            if success {
                addRoom(room: newRoom, to: &map)
                if rooms.count > 1 {
                    let previousCenter = rooms[rooms.count - 1].center
                        
                    if Bool.random() {
                        addHorizontalCorridor(x1: Int(previousCenter.x), x2: Int(newRoom.center.x), y: Int(previousCenter.y), roomMap: &map)
                        addVerticalCorridor(y1: Int(previousCenter.y), y2: Int(newRoom.center.y), x: Int(newRoom.center.x), roomMap: &map)
                    } else {
                        addVerticalCorridor(y1: Int(previousCenter.y), y2: Int(newRoom.center.y), x: Int(previousCenter.x), roomMap: &map)
                        addHorizontalCorridor(x1: Int(previousCenter.x), x2: Int(newRoom.center.x), y: Int(newRoom.center.y), roomMap: &map)
                    }
                }
                rooms.append(newRoom)
            }
        }
        
        var entities = [Entity]()
        
//        for room in rooms {
//            if let roomDefinition = roomDefinition(for: room) {
//                entities.append(contentsOf: roomDefinition.generate(in: room))
//            }
//        }
        
        return FilledMap(roomMap: map, entities: entities)
    }
    
//    func roomDefinition(for room: RectangularRoom) -> MaskRoomDefinition? {
//        var possibleRooms = [MaskRoomDefinition]()
//        for definition in roomDefinitions where definition.fits(in: room) {
//            possibleRooms.append(definition)
//        }
//
//        if possibleRooms.isEmpty { return nil }
//        let index = Int.random(in: 0..<possibleRooms.count)
//        return possibleRooms[index]
//    }
}

extension RoomMap {
    func nearbyRoom(_ room: RectangularRoom, _ x: Int, _ y: Int, _ dx: Int = 1, _ dy: Int = 1) -> Bool {
        guard x-dx > 0, x+dx < [0].count, y-dy > 0, y+dy < count else { return true }
        for px in x-dx...x+dx {
            for py in y-dy...y+dy {
                if !room.contains(px, py), self[py][px] {
                    return true
                }
            }
        }
        return false
    }
}
