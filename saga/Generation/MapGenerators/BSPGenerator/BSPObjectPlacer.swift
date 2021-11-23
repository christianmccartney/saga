//
//  BSPObjectPlacer.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import Foundation

public class BSPObjectPlacer: ObjectPlacer {
    private static let libraryMinWidth = 4
    private static let libraryMinHeight = 4
    private static let libraryMaxWidth = 20
    private static let libraryMaxHeight = 20
    
//    private func addObjectDefinitions(_ definitions: [ObjectDefinition],
//                                      location: RoomLocation,
//                                      roomLeaf: RoomLeaf) {
//    }
    public init() {
        let bookshelfDefinition = StaticObjectLocation(definitions: [], location: .south)
        let libraryDefinition = RoomDefinition(
            minWidth: BSPObjectPlacer.libraryMinWidth,
            minHeight: BSPObjectPlacer.libraryMinHeight,
            maxWidth: BSPObjectPlacer.libraryMaxWidth,
            maxHeight: BSPObjectPlacer.libraryMaxHeight,
            staticObjectLocations: [bookshelfDefinition])
        super.init(roomDefinitions: [libraryDefinition])
    }
    
    func createRoom(in leaf: RoomLeaf, room: RectangularRoom) -> Bool {
//        guard let room = leaf.getRoom() else { return false }
//        guard room.width > BSPObjectPlacer.libraryMinWidth,
//              room.width < BSPObjectPlacer.libraryMaxWidth,
//              room.height > BSPObjectPlacer.libraryMinHeight,
//              room.height < BSPObjectPlacer.libraryMaxHeight else { return false }
//        print("creating room")
//
//        let index = Int.random(in: 0..<roomDefinitions.count)
//        for definition in roomDefinitions[index].objectDefinitions {
//
//            for location in definition.locations {
//                let ranges = location.ranges(room.x1, room.y1, room.x2, room.y2)
//
//                for x in ranges.0 {
//                    for y in ranges.1 {
//                        if Int.random(in: 0..<100) < definition.spawnChance,
//                           !leaf.hallways.contains(where: { $0.nearby(x, y) }) {
//                            let object = definition.object.copyEntity()
//                            object.position = Position(x, y)
//                            entities.append(object)
//                        }
//                    }
//                }
//            }
//        }
        return true
    }
    
}
