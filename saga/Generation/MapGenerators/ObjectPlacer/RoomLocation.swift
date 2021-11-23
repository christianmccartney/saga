//
//  RoomLocation.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import Foundation

public enum RoomLocation {
    case north(Int)
    case east(Int)
    case south(Int)
    case west(Int)
    case northEast(Int, Int)
    case northWest(Int, Int)
    case southEast(Int, Int)
    case southWest(Int, Int)
    case center(Int, Int)
    case horizontal(Int)
    case qHorizontal(Int)
    case tqHorizontal(Int)
    case vertical(Int)
    case qVertical(Int)
    case tqVertical(Int)
    
    // CAREFUL: Absolutely awful in every way, what the hell
    func ranges(_ room: RectangularRoom) -> (Range<Int>, Range<Int>) {
        let x1 = room.x1
        let x2 = room.x2
        let y1 = room.y1
        let y2 = room.y2
        precondition(x1+1 < x2-1 && y1+1 < y2-1)
        switch self {
        case .north(let offset):
            return (x1+1..<x2-1, y2+offset-1..<y2+offset)
        case .south(let offset):
            return (x1+1..<x2-1, y1+offset..<y1+offset+1)
        case .east(let offset):
            return (x2+offset..<x2+offset+1, y1+1..<y2-1)
        case .west(let offset):
            return (x1+offset..<x1+offset+1, y1+1..<y2-1)
        case .northEast(let xOffset, let yOffset):
            return (x2+xOffset-1..<x2+xOffset, y2+yOffset-1..<y2+yOffset)
        case .northWest(let xOffset, let yOffset):
            return (x1+xOffset..<x1+xOffset+1, y2+yOffset-1..<y2+yOffset)
        case .southEast(let xOffset, let yOffset):
            return (x2+xOffset-1..<x2+xOffset, y1+yOffset..<y1+yOffset+1)
        case .southWest(let xOffset, let yOffset):
            return (x1+xOffset..<x1+xOffset+1, y1+yOffset..<y1+yOffset+1)
        case .center(let xOffset, let yOffset):
            return (x1+1+xOffset..<x2-xOffset-1, y1+1+yOffset..<y2-yOffset-1)
        case .horizontal(let offset):
            let y = (y1 + y2) / 2
            return (x1+1..<x2-1, y+offset..<y+offset+1)
        case .qHorizontal(let offset):
            let y = ((y1 + y2) / 2) - (room.height / 4)
            return (x1+1..<x2-1, y+offset..<y+offset+1)
        case .tqHorizontal(let offset):
            let y = ((y1 + y2) / 2) + (room.height / 4)
            return (x1+1..<x2-1, y+offset..<y+offset+1)
        case .vertical(let offset):
            let x = (x1 + x2) / 2
            return (x+offset..<x+offset+1, y1+1..<y2-1)
        case .qVertical(let offset):
            let x = ((x1 + x2) / 2) - (room.width / 4)
            return (x+offset..<x+offset+1, y1+1..<y2-1)
        case .tqVertical(let offset):
            let x = ((x1 + x2) / 2) + (room.width / 4)
            return (x+offset..<x+offset+1, y1+1..<y2-1)
        }
    }
}

struct RoomMask {
    
}
