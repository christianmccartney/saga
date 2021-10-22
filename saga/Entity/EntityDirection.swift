//
//  EntityDirection.swift
//  Saga
//
//  Created by Christian McCartney on 5/25/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

public enum EntityDirection: Int {
    case down = 0
    case right = 1
    case up = 2
    case left = 3

    var directionVector: simd_float2 {
        switch self {
        case .down:
            return simd_float2(x: 0, y: -1)
        case .right:
            return simd_float2(x: 1, y: 0)
        case .up:
            return simd_float2(x: 0, y: 1)
        case .left:
            return simd_float2(x: -1, y: 0)
        }
    }

    static func fromDirection(_ direction: simd_float2) -> EntityDirection? {
        if direction == simd_float2(x: 0, y: -1) {
            return .down
        } else if direction == simd_float2(x: 1, y: 0) {
            return .right
        } else if direction == simd_float2(x: 0, y: 1) {
            return .up
        } else if direction == simd_float2(x: -1, y: 0) {
            return .left
        }
        return nil
    }
}

extension EntityDirection {
    static let directions: [EntityDirection] = [.down, .right, .up, .left]

    func toString() -> String {
        switch self {
        case .down:
            return "_d1"
        case .right:
            return "_r1"
        case .up:
            return "_u1"
        case .left:
            return "_l1"
        }
    }

    func toString2() -> String {
        switch self {
        case .down:
            return "_d2"
        case .right:
            return "_r2"
        case .up:
            return "_u2"
        case .left:
            return "_l2"
        }
    }
}

extension EntityDirection {
    func rotateRight() -> EntityDirection {
        let newRotation = (self.rawValue + 90) % 360
        return EntityDirection(rawValue: newRotation) ?? .down
    }

    func rotateLeft() -> EntityDirection {
        let newRotation = (self.rawValue - 90) % 360
        return EntityDirection(rawValue: newRotation) ?? .down
    }

    func getNewDirection(_ previousPosition: Position, _ newPosition: Position, _ lastDirection: EntityDirection) -> EntityDirection {
        let delta_x = newPosition.column - previousPosition.column
        let delta_y = newPosition.row - previousPosition.row
        let theta = atan2(Double(delta_x), Double(delta_y))

        var degrees = theta * (180.0 / .pi) // convert to degrees
        degrees = (degrees > 0.0 ? degrees : (360.0 + degrees))

        let delta_degrees = Int(degrees) - self.rawValue

//        if delta_degrees > 0.0 {
//            return self.rotateRight()
//        } else if delta_degrees < 0.0 {
//            return self.rotateLeft()
//        }
//        print(previousPosition)
//        print(newPosition)
//        print(delta_degrees)
//        print((Int(delta_degrees) + self.rawValue) % 360)
//        print(EntityDirection(rawValue: (Int(delta_degrees) + self.rawValue) % 360))
//        print()
//        if delta_degrees > 90.0 {
//            return self.rotateRight().rotateRight()
//        } else if delta_degrees > 0.0 {
//            return self.rotateRight()
//        } else if delta_degrees < -90.0 {
//            return self.rotateLeft().rotateLeft()
//        } else if delta_degrees < 0.0 {
//            return self.rotateLeft()
//        }
        return EntityDirection(rawValue: (Int(delta_degrees) + self.rawValue) % 360) ?? lastDirection
    }
}
