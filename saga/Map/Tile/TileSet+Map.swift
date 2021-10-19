//
//  TileSet+Map.swift
//  saga
//
//  Created by Christian McCartney on 10/18/21.
//

import Foundation
import SpriteKit

// 0 = floor
// 1 = horizontal
// 2 = vertical
// 3 = none

// 2 1 1 1 2
// 2 0 0 0 2
// 2 0 0 0 2
// 2 0 0 0 2
// 2 2 2 2 2

extension SKTileMapNode {
    func mapGridPosition(for tileLocation: Position, with roomMap: RoomMap) -> Int {
        if roomMap[tileLocation.row][tileLocation.column] {
            return 0
        }
        let y1 = tileLocation.row - 1
        let y2 = tileLocation.row + 1
        let x1 = tileLocation.column - 1
        let x2 = tileLocation.column + 1
        guard y2 < roomMap.count else {
            return 3
        }
        guard x2 < roomMap[0].count else {
            return 3
        }
        guard y1 > 0 else {
            return 3
        }
        guard x1 > 0 else {
            return 3
        }
        if roomMap[y1][tileLocation.column] {
            return 1
        }
        if roomMap[y2][tileLocation.column] {
            return 2
        }
        if roomMap[tileLocation.row][x1] {
            return 2
        }
        if roomMap[tileLocation.row][x2] {
            return 2
        }
        if ((roomMap[y1][x1] != roomMap[y2][x1]) != roomMap[y1][x2]) != roomMap[y2][x2] {
            return 2
        }
        return 3
    }
}

extension SKTileSet {
    func mapTileDefinition(for tileType: Int) -> SKTileGroup? {
        guard tileType < tileGroups.count else { return nil }
        return tileGroups[tileType]
    }
}
