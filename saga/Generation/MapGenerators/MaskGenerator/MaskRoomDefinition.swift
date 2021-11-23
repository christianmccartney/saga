//
//  MaskRoomDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import CoreGraphics

public struct MaskStaticObject {
    let entity: StaticObjectType
    let chance: Int
}

public struct MaskStaticObjectDefinition {
    let shape: ShapeMask
    let entities: [MaskStaticObject]
    
    var entity: StaticObjectType? {
        let p = Int.random(in: 0..<100)
        return entities.first { p < $0.chance }?.entity
    }
}

public struct MaskRoomDefinition {
    /// Minimum width of a room that this definition could apply to.
    let minWidth: Int
    /// Minimum height of a room that this definition could apply to.
    let minHeight: Int
    /// Maximum width of a room that this definition could apply to.
    let maxWidth: Int
    /// Maximum height of a room that this definition could apply to.
    let maxHeight: Int
    /// The entity definitions for this room.
    var staticObjectDefinitions: [MaskStaticObjectDefinition]
    
    func fits(in room: RectangularRoom) -> Bool {
        return room.width > minWidth && room.width < maxWidth && room.height > minHeight && room.height < maxHeight
    }
    
    /// Generate a concrete room.
    func generate(in room: RectangularRoom) -> [Entity] {
        var entities = [Entity]()
        for x in 0..<room.width {
            for y in 0..<room.height {
                if let staticObjectType = staticObject(
                    at: CGPoint(x: CGFloat(x), y: CGFloat(y)),
                    scale: CGVector(dx: CGFloat(room.width), dy: CGFloat(room.height))) {
                    
                    let object = StaticObject(type: staticObjectType)
                    object.position = Position(x+room.x1, y+room.y1)
                    entities.append(object)
                }
            }
        }
        return entities
//        for entityDefinition in entityDefinitions {
//
//        }
    }

    private func staticObject(at point: CGPoint, scale: CGVector) -> StaticObjectType? {
        let types: [StaticObjectType] = staticObjectDefinitions.compactMap { definition in
            if definition.shape.contains(point, scale) {
                return definition.entity
            }
            return nil
        }
        return types.first
    }
}
