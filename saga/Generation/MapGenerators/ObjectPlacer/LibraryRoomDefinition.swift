//
//  LibraryRoomDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import CoreGraphics

enum LibraryRoomDefinition {
    private static let bookshelf = StaticObjectDefinition(type: StaticObjectType.bookshelf_a, spawnChance: 75)
    private static let bookshelfEmpty = StaticObjectDefinition(type: StaticObjectType.bookshelf_b, spawnChance: 100)
    private static let tableLeft = StaticObjectDefinition(type: StaticObjectType.table_left_b, spawnChance: 25)
    private static let tableRight = StaticObjectDefinition(type: StaticObjectType.table_right_b, spawnChance: 50)
    
    private static let carpet = StaticObjectDefinition(type: StaticObjectType.floor_carpet_a, spawnChance: 100)
    
    private static let candlea =    DynamicObjectDefinition(type: DynamicObjectType.candles_a, spawnChance: 5)
    private static let candleb =    DynamicObjectDefinition(type: DynamicObjectType.candles_b, spawnChance: 10)
    private static let candlec =    DynamicObjectDefinition(type: DynamicObjectType.candles_b, spawnChance: 15)
    
    private static let topRowBookshelf =    ObjectLocation(definitions: [bookshelf, bookshelfEmpty],
                                                           location: .north(0))
    private static let middleRowBookshelf = ObjectLocation(definitions: [bookshelf, bookshelfEmpty],
                                                           location: .horizontal(0))
    private static let tqRowBookshelf =     ObjectLocation(definitions: [bookshelf, bookshelfEmpty],
                                                           location: .tqHorizontal(0))
    private static let bottomRowTable =     ObjectLocation(definitions: [tableLeft, tableRight],
                                                           location: .south(0))
    
    private static let qMiddleRowCarpet =   ObjectLocation(definitions: [carpet],
                                                           location: .qHorizontal(0))
    private static let tqMiddleRowCarpet =  ObjectLocation(definitions: [carpet],
                                                           location: .tqHorizontal(0))
    private static let qMiddleRowCarpetM =  ObjectLocation(definitions: [carpet],
                                                           location: .qHorizontal(1))
    
    private static let libraryCornerNE = ObjectLocation(
        definitions: [AnyRoomDefinition.torch, candlea, candleb, candlec, AnyRoomDefinition.cobwebNE],
        location: .northEast(0, 0))
    private static let libraryCornerNW = ObjectLocation(
        definitions: [AnyRoomDefinition.torch, candlea, candleb, candlec, AnyRoomDefinition.cobwebNW],
        location: .northWest(0, 0))
    private static let libraryCornerSE = ObjectLocation(
        definitions: [AnyRoomDefinition.torch, candlea, candleb, candlec, AnyRoomDefinition.cobwebSE],
        location: .southEast(0, 0))
    private static let libraryCornerSW = ObjectLocation(
        definitions: [AnyRoomDefinition.torch, candlea, candleb, candlec, AnyRoomDefinition.cobwebSW],
        location: .southWest(0, 0))
    
    static let smallLibraryRoomDefinition = RoomDefinition(minWidth: 4, minHeight: 4, maxWidth: 7, maxHeight: 7,
                                                           objectLocations: [topRowBookshelf,
                                                                             qMiddleRowCarpet,
                                                                             middleRowBookshelf,
                                                                             tqMiddleRowCarpet,
                                                                             bottomRowTable,
                                                                             libraryCornerNE,
                                                                             libraryCornerNW,
                                                                             libraryCornerSE,
                                                                             libraryCornerSW,
                                                                            ])
    
    static let mediumLibraryRoomDefinition = RoomDefinition(minWidth: 7, minHeight: 7, maxWidth: 9, maxHeight: 9,
                                                            objectLocations: [topRowBookshelf,
                                                                              qMiddleRowCarpetM,
                                                                              middleRowBookshelf,
                                                                              tqMiddleRowCarpet,
                                                                              bottomRowTable,
                                                                              libraryCornerNE,
                                                                              libraryCornerNW,
                                                                              libraryCornerSE,
                                                                              libraryCornerSW,
                                                                             ])
    
}
