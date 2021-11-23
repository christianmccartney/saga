//
//  CryptDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

enum CryptDefinition {
    static let cryptObjectPlacer = ObjectPlacer(
        roomDefinitions: [LibraryRoomDefinition.smallLibraryRoomDefinition,
                          LibraryRoomDefinition.mediumLibraryRoomDefinition,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition1,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition2,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition3,
                          WarehouseRoomDefinition.smallWarehouseRoomDefinition4,
                         ])
    static let dungeonGenerator = MapGenerator(width: 48, height: 48,
                                               objectPlacer: cryptObjectPlacer)
    
    static let stoneTileDefinition = TileGroupDefinition(
        name: "stoneCobble",
        verticalWallType: .stone,
        horizontalWallType: .stone,
        floorType: .cobble2)
    
    static let stoneTileSet = TileSet(stoneTileDefinition)
}
