//
//  RoomDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

enum AnyRoomDefinition {
    static let cobwebNE =   StaticObjectDefinition(type: StaticObjectType.web_ne, spawnChance: 100)
    static let cobwebNW =   StaticObjectDefinition(type: StaticObjectType.web_nw, spawnChance: 100)
    static let cobwebSE =   StaticObjectDefinition(type: StaticObjectType.web_se, spawnChance: 100)
    static let cobwebSW =   StaticObjectDefinition(type: StaticObjectType.web_sw, spawnChance: 100)
    
    static let torch =  DynamicObjectDefinition(type: DynamicObjectType.torch, spawnChance: 30)
    
    static let cornerNE = ObjectLocation(
        definitions: [torch, cobwebNE],
        location: .northEast(0, 0))
    static let cornerNW = ObjectLocation(
        definitions: [torch, cobwebNW],
        location: .northWest(0, 0))
    static let cornerSE = ObjectLocation(
        definitions: [torch, cobwebSE],
        location: .southEast(0, 0))
    static let cornerSW = ObjectLocation(
        definitions: [torch, cobwebSW],
        location: .southWest(0, 0))
    
}
