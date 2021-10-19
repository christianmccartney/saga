//
//  TileSet+Interface.swift
//  saga
//
//  Created by Christian McCartney on 10/16/21.
//

import SpriteKit

// 6 7 8
// 3 4 5
// 0 1 2

extension SKTileMapNode {
    func interfaceGridPosition(for tileLocation: Position) -> Int {
        if tileLocation.column == 0 {
            if tileLocation.row == 0 {
                return 6
            }
            if tileLocation.row == numberOfRows-1 {
                return 0
            }
            return 3
        }
        if tileLocation.column == numberOfColumns-1 {
            if tileLocation.row == 0 {
                return 8
            }
            if tileLocation.row == numberOfRows-1 {
                return 2
            }
            return 5
        }
        if tileLocation.row == 0 {
            return 7
        }
        if tileLocation.row == numberOfRows-1 {
            return 1
        }
        return 4
    }
}

extension SKTileGroup {
    func interfaceTileDefinition(for gridPosition: Int) -> SKTileDefinition? {
        return rules.first?.tileDefinitions[gridPosition]
    }
}

