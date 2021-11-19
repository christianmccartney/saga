//
//  SKTileMapNode.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

import SpriteKit

extension SKTileMapNode {
    func fillWithEdges(_ tileGroup: SKTileGroup) {
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let gridPosition = interfaceGridPosition(for: Position(column, row))
                if let tileDefinition = tileGroup.interfaceTileDefinition(for: gridPosition) {
                    setTileGroup(tileGroup,
                                 andTileDefinition: tileDefinition,
                                 forColumn: column,
                                 row: row)
                }
            }
        }
    }
}
