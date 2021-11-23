//
//  ObjectDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

protocol ObjectDefinition {
    var spawnChance: Int { get }
}

/// A `StaticObjectDefinition` describes an object and its spawn chance
public struct StaticObjectDefinition: ObjectDefinition {
    /// The object type.
    let type: StaticObjectType
    /// Probability of spawning, 0 = never, 100 = always.
    let spawnChance: Int
}

public struct DynamicObjectDefinition: ObjectDefinition {
    /// The object type.
    let type: DynamicObjectType
    /// Probability of spawning, 0 = never, 100 = always.
    let spawnChance: Int
}

public struct ObjectLocation {
    let definitions: [ObjectDefinition]
    /// The locations that the object may spawn.
    let location: RoomLocation
    
    private var definition: ObjectDefinition? {
        definitions.first { Int.random(in: 0..<100) < $0.spawnChance }
    }
    
    var entity: Entity? {
        let objectDef = definition
        if let staticDef = objectDef as? StaticObjectDefinition {
            return StaticObject(type: staticDef.type)
        } else if let dynamicDef = objectDef as? DynamicObjectDefinition {
            return DynamicObject(type: dynamicDef.type)
        }
        return nil
    }

    init(definitions: [ObjectDefinition], location: RoomLocation) {
        self.definitions = definitions.sorted { $0.spawnChance < $1.spawnChance }
        self.location = location
    }
}
