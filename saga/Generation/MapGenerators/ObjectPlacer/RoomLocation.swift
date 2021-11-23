//
//  RoomLocation.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import Foundation

public enum RoomLocation {
    case north
    case east
    case south
    case west
    case northEast
    case northWest
    case southEast
    case southWest
    case center
    case horizontal
    case vertical
    case qHorizontal
    case tqHorizontal
    case qVertical
    case tqVertical
    
    func ranges(_ room: RectangularRoom) -> (ClosedRange<Int>, ClosedRange<Int>) {
        let x1 = room.x1
        let x2 = room.x2
        let y1 = room.y1
        let y2 = room.y2
        precondition(x1+1 < x2-1 && y1+1 < y2-1)
        switch self {
        case .north:
            return (x1+1...x2-1, y2...y2)
        case .south:
            return (x1+1...x2-1, y1...y1)
        case .east:
            return (x2...x2, y1+1...y2-1)
        case .west:
            return (x1...x1, y1+1...y2-1)
        case .northEast:
            return (x2...x2, y2...y2)
        case .northWest:
            return (x1...x1, y2...y2)
        case .southEast:
            return (x2...x2, y1...y1)
        case .southWest:
            return (x1...x1, y1...y1)
        case .center:
            return (x1+1...x2-1, y1+1...y2-1)
        case .horizontal:
            let y = (y1 + y2) / 2
            return (x1+1...x2-1, y...y)
        case .vertical:
            let x = (x1 + x2) / 2
            return (x...x, y1+1...y2-1)
        case .qHorizontal:
            let y = ((y1 + y2) / 2) - (room.height / 4)
            return (x1+1...x2-1, y...y)
        case .tqHorizontal:
            let y = ((y1 + y2) / 2) + (room.height / 4)
            return (x1+1...x2-1, y...y)
        case .qVertical:
            let x = ((x1 + x2) / 2) - (room.width / 4)
            return (x...x, y1+1...y2-1)
        case .tqVertical:
            let x = ((x1 + x2) / 2) + (room.width / 4)
            return (x...x, y1+1...y2-1)
        }
    }
}

struct RoomMask {
    
}
