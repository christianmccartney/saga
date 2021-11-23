//
//  BSPGenerator.swift
//  saga
//
//  Created by Christian McCartney on 10/16/21.
//

import Foundation
import CoreGraphics

// Generates a map using binary space partition
class BSPGenerator: MapGenerator {
    let divisions: Int
//    private let objectPlacer: BSPObjectPlacer
    private var rootLeaf: RoomLeaf

    public init(width: Int, height: Int, divisions: Int, objectPlacer: BSPObjectPlacer) {
        self.divisions = divisions
//        self.objectPlacer = objectPlacer
        self.rootLeaf = RoomLeaf(x: 0, y: 0, width: width - 2, height: height - 2)
        super.init(width: width, height: height, objectPlacer: objectPlacer)
    }
    
    override func generate() -> FilledMap {
        var roomMap: RoomMap = Array(repeating: Array(repeating: false, count: width), count: height)
        
        func splitLeaf(roomLeaf: RoomLeaf, depth: Int) {
            guard depth > 0 else { return }
            roomLeaf.split()
            if let leftLeaf = roomLeaf.leftChild {
                splitLeaf(roomLeaf: leftLeaf, depth: depth - 1)
            }
            if let rightLeaf = roomLeaf.rightChild {
                splitLeaf(roomLeaf: rightLeaf, depth: depth - 1)
            }
        }
        
        splitLeaf(roomLeaf: rootLeaf, depth: divisions)
        rootLeaf.createRooms()
    
        func addRooms(to roomMap: inout RoomMap, roomLeaf: RoomLeaf) {
            if let room = roomLeaf.getRoom() {
                room.addRoom(to: &roomMap)
            }
            for hallway in roomLeaf.hallways {
                hallway.addRoom(to: &roomMap)
            }
            if let leftLeaf = roomLeaf.leftChild {
                addRooms(to: &roomMap, roomLeaf: leftLeaf)
            }
            if let rightLeaf = roomLeaf.rightChild {
                addRooms(to: &roomMap, roomLeaf: rightLeaf)
            }
        }
        
        addRooms(to: &roomMap, roomLeaf: rootLeaf)
        return FilledMap(roomMap: roomMap, entities: [])
    }

    override func createRooms() {
//        createRoom(rootLeaf)
    }
    
    var bspObjectPlacer: BSPObjectPlacer {
        return objectPlacer as! BSPObjectPlacer
    }

//    private func createRoom(_ leaf: RoomLeaf) {
//        if bspObjectPlacer.createRoom(in: leaf) {
//            return
//        } else {
//            if let leftLeaf = leaf.leftChild {
//                createRoom(leftLeaf)
//            }
//            if let rightLeaf = leaf.rightChild {
//                createRoom(rightLeaf)
//            }
//        }
//    }
}

struct Point {
    let x: Int
    let y: Int
}

class RoomLeaf {
    let minLeafSize = 7

    var x: Int
    var y: Int
    var width: Int
    var height: Int
    
    var leftChild: RoomLeaf?
    var rightChild: RoomLeaf?
    
    var room: RectangularRoom?
    var hallways = [RectangularRoom]()

    init(x: Int, y: Int, width: Int, height: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    @discardableResult
    func split() -> Bool {
            // Split leaf into 2 children
        if (leftChild != nil || rightChild != nil) { return false }
        // Already split
    
        // Determine split direction
        // If width >25% larger than height, split vertically
        // Otherwise if height >25% larger than width, split horizontally
        // if none of these, split randomly
        var splitH = Int.random(in: 0..<100) > 50 ? true : false
    
        if width > height && Double(height / width) >= 1.25 {
            splitH = false;
        } else if height > width && Double(width / height) >= 1.25 {
            splitH = true;
        }
    
        let max = (splitH ? height : width) - minLeafSize // determine the maximum height or width
        if max <= minLeafSize { return false } // the area is too small to split any more...
    
        // determine where we're going to split
        let split = Int.random(in: minLeafSize..<max)//Int(arc4random_uniform(UInt32(max + minLeafSize) - UInt32(minLeafSize)))
    
        // Create children based on split direction
        if (splitH) {
            leftChild = RoomLeaf(x: x, y: y, width: width, height: split);
            rightChild = RoomLeaf(x: x, y: y + split, width: width, height: height - split)
        } else {
            leftChild = RoomLeaf(x: x, y: y, width: split, height: height);
            rightChild = RoomLeaf(x: x + split, y: y, width: width - split, height: height)
        }
        return true
    }

    func getRoom() -> RectangularRoom? {
        
        if let _ = room {
            return room
        } else {
        
            let lRoom = leftChild?.getRoom()
            let rRoom = rightChild?.getRoom()
        
            switch (lRoom != nil, rRoom != nil) {
            case (false, false):
                return nil
            case (true, false):
                return lRoom
            case (false, true):
                return rRoom
            case (true, true):
                return Double.random(in: 0..<1.0) > 0.5 ? lRoom : rRoom
            }
        }
    }
    
    func createRooms() {
    // Generates all rooms and hallways for this leaf and its children
        if leftChild != nil || rightChild != nil {
            // This leaf has been split, go to children leafs
            if leftChild != nil {
                leftChild!.createRooms()
            }
            if rightChild != nil {
                rightChild!.createRooms()
            }
            // If there are both left and right children in leaf, make hallway between them
            if leftChild != nil && rightChild != nil {
                // If there is a room in either the left or right leaves
                guard let leftRoom = leftChild!.getRoom(), let rightRoom = rightChild!.getRoom() else { return }
                
                // If there is, create a hall between them
                createHall(left: leftRoom, right: rightRoom)
            }
        } else if Int.random(in: 0..<100) > 25 {
            // Room can be between 3x3 tiles to (leaf.size - 2)
            let xSize = Int.random(in: 4..<(width - 2))
            let ySize = Int.random(in: 4..<(height - 2))
            let roomSize = CGPoint(x: xSize, y: ySize)
            
            // Place the room within leaf, but not against sides. It would merge with other rooms.
            let roomPos = CGPoint(x: Int.random(in: 2..<(width - Int(roomSize.x))),
                                  y: Int.random(in: 2..<(height - Int(roomSize.y))))
            
            room = RectangularRoom(x: x + Int(roomPos.x), y: y + Int(roomPos.y), width: Int(roomSize.x), height: Int(roomSize.y))
        }
    }

    func createHall(left: RectangularRoom, right: RectangularRoom) {
        // Connects 2 rooms together with hallways
        hallways = []
    
        // Get width and height of first room
        let point1 = Point(x: Int.random(in: (left.x1 + 1)..<(left.x2 - 1)),
                           y: Int.random(in: (left.y1 + 1)..<(left.y2 - 1)))
        
        // Get width and height of second room
        let point2 = Point(x: Int.random(in: (right.x1 + 1)..<(right.x2 - 1)),
                           y: Int.random(in: (right.y1 + 1)..<(right.y2 - 1)))
        
        if Bool.random() {
            // Horizontally first, then vertically:
            // From point1 to min(point2.x, point1.y):
            hallways.append(RectangularRoom(x: min(point1.x, point2.x), y: point1.y,
                                 width: Int(abs(point1.x - point2.x)), height: 0))
            // From (point2.x, point1.y) to point2:
            hallways.append(RectangularRoom(x: point2.x, y: min(point1.y, point2.y),
                                 width: 0, height: Int(abs(point1.y - point2.y))))
        } else {
            // Vertically first, then Horizontally:
            // From point1 to min(point1.x, point2.y):
            hallways.append(RectangularRoom(x: point1.x, y: min(point1.y, point2.y),
                                 width: 0, height: Int(abs(point1.y - point2.y))))
            // From (point1.x, point2.y) to point2:
            hallways.append(RectangularRoom(x: min(point1.x, point2.x), y: point2.y,
                                 width: Int(abs(point1.x - point2.x)), height: 0))
        }
    }
}
