//
//  LibraryRoomDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import CoreGraphics

enum LibraryRoomDefinition {
//    private static let topRowBookshelf = MaskStaticObjectDefinition(
//        shape: LineMask(a: CGPoint(x: 0.0, y: 1.0), b: CGPoint(x: 1.0, y: 1.0)),
//        entities: [MaskStaticObject(entity: StaticObjectType.bookshelf_full, chance: 75),
//                   MaskStaticObject(entity: StaticObjectType.bookshelf_empty, chance: 100)])
//
//    private static let middleRowBookshelf = MaskStaticObjectDefinition(
//        shape: LineMask(a: CGPoint(x: 0.0, y: 0.5), b: CGPoint(x: 1.0, y: 0.5)),
//        entities: [MaskStaticObject(entity: StaticObjectType.bookshelf_full, chance: 75),
//                   MaskStaticObject(entity: StaticObjectType.bookshelf_empty, chance: 100)])
//
//    private static let bottomRowTable = MaskStaticObjectDefinition(
//        shape: LineMask(a: CGPoint(x: 0.0, y: 0.0), b: CGPoint(x: 1.0, y: 0.0)),
//        entities: [MaskStaticObject(entity: StaticObjectType.table, chance: 10)])
//
//    static let smallLibraryRoomDefinition = MaskRoomDefinition(minWidth: 5, minHeight: 5,
//                                                               maxWidth: 7, maxHeight: 7,
//                                                               staticObjectDefinitions: [topRowBookshelf,
//                                                                                         middleRowBookshelf,
//                                                                                         bottomRowTable])
    private static let bookshelf = StaticObjectDefinition(type: .bookshelf_a, spawnChance: 75)
    private static let bookshelfEmpty = StaticObjectDefinition(type: .bookshelf_b, spawnChance: 100)
    private static let table = StaticObjectDefinition(type: .table, spawnChance: 25)
    
    private static let carpet = StaticObjectDefinition(type: .floor_carpet_a, spawnChance: 100)
    
    private static let topRowBookshelf = StaticObjectLocation(definitions: [bookshelf, bookshelfEmpty],
                                                              location: .north)
    private static let middleRowBookshelf = StaticObjectLocation(definitions: [bookshelf, bookshelfEmpty],
                                                                 location: .horizontal)
    private static let tqMiddleRowBookshelf = StaticObjectLocation(definitions: [bookshelf, bookshelfEmpty],
                                                                   location: .tqHorizontal)
    private static let bottomRowTable = StaticObjectLocation(definitions: [table], location: .south)
    
    private static let qMiddleRowCarpet = StaticObjectLocation(definitions: [carpet],
                                                               location: .qHorizontal)
    
    private static let tqMiddleRowCarpet = StaticObjectLocation(definitions: [carpet],
                                                                location: .tqHorizontal)
    
    static let smallLibraryRoomDefinition = RoomDefinition(minWidth: 5, minHeight: 5, maxWidth: 7, maxHeight: 7,
                                                           staticObjectLocations: [topRowBookshelf,
                                                                                   middleRowBookshelf,
                                                                                   bottomRowTable])
    
    static let mediumLibraryRoomDefinition = RoomDefinition(minWidth: 7, minHeight: 7, maxWidth: 9, maxHeight: 9,
                                                            staticObjectLocations: [topRowBookshelf,
                                                                                    qMiddleRowCarpet,
                                                                                    middleRowBookshelf,
                                                                                    tqMiddleRowCarpet,
                                                                                    bottomRowTable])
}
