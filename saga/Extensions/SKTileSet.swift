//
//  SKTileSet.swift
//  saga
//
//  Created by Christian McCartney on 11/23/21.
//

import SpriteKit

extension SKTileSet {
    func mapTileDefinition(for tileType: Int) -> SKTileGroup? {
        guard tileType < tileGroups.count else { return nil }
        return tileGroups[tileType]
    }
}
