//
//  ObjectPlacer.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

/// An `CreatureDefinition` describes an object, its spawn chance and where in a room it can be placed.
public struct CreatureDefinition {
    /// The object type.
    let type: CreatureType
    /// Percentage change of spawning, 0 = never, 100 = always.
    let spawnChance: Int
    /// The locations that the object may spawn.
    let location: RoomLocation
}

/// A `StaticObjectDefinition` describes an object and its spawn chance
public struct StaticObjectDefinition {
    /// The object type.
    let type: StaticObjectType
    /// Probability of spawning, 0 = never, 100 = always.
    let spawnChance: Int
}

public struct StaticObjectLocation {
    let definitions: [StaticObjectDefinition]
    /// The locations that the object may spawn.
    let location: RoomLocation
    /// The maximum number of objects to place.
    var definition: StaticObjectDefinition? {
        definitions.first { Int.random(in: 0..<100) < $0.spawnChance }
    }
}

/// A `RoomDefinition` describes the size of a possible room and what objects could populate it.
public struct RoomDefinition {
    /// Minimum width of a room that this definition could apply to.
    let minWidth: Int
    /// Minimum height of a room that this definition could apply to.
    let minHeight: Int
    /// Maximum width of a room that this definition could apply to.
    let maxWidth: Int
    /// Maximum height of a room that this definition could apply to.
    let maxHeight: Int
    /// The static object definitions for this room.
    var staticObjectLocations: [StaticObjectLocation]
    
    func fits(in room: RectangularRoom) -> Bool {
        return room.width > minWidth && room.width < maxWidth && room.height > minHeight && room.height < maxHeight
    }
}

open class ObjectPlacer {
    var roomDefinitions: [RoomDefinition]
    var entities: [Entity] = []

    public init(roomDefinitions: [RoomDefinition] = []) {
        self.roomDefinitions = roomDefinitions
    }

    func entities(for room: RectangularRoom) -> [Entity] {
        var entities = [Entity]()
        var possibleDefinitions = [RoomDefinition]()
        for definition in roomDefinitions {
            if definition.fits(in: room) {
                possibleDefinitions.append(definition)
            }
        }
        guard !possibleDefinitions.isEmpty else { return entities }
        let index = Int.random(in: 0..<possibleDefinitions.count)
        
        for objectLocation in possibleDefinitions[index].staticObjectLocations {
            let ranges = objectLocation.location.ranges(room)
            for x in ranges.0 {
                for y in ranges.1 {
                    if let object = objectLocation.definition {
                        let object = StaticObject(type: object.type)
                        object.position = Position(x, y)
                        entities.append(object)
                    }
                }
            }
        }
        return entities
    }
}
