//
//  RandomRoomGenerator.swift
//  saga
//
//  Created by Christian McCartney on 10/14/21.
//

// Generates a map by randomly adding rooms
class RandomRoomGenerator: MapGenerator {
    let maxRooms: Int
    let minRoomSize: Int
    let maxRoomSize: Int

    public init(width: Int, height: Int, maxRooms: Int, minRoomSize: Int = 5, maxRoomSize: Int = 12) {
        self.maxRooms = maxRooms
        self.minRoomSize = minRoomSize
        self.maxRoomSize = maxRoomSize
        super.init(width: width, height: height)
    }

    override func generate() -> RoomMap {
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
        
        return map
    }
}
