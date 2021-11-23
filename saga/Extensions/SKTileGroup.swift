//
//  SKTileGroup.swift
//  saga
//
//  Created by Christian McCartney on 11/19/21.
//

import SpriteKit

extension SKTileGroup {
    func interfaceTileDefinition(for gridPosition: Int) -> SKTileDefinition? {
        return rules.first?.tileDefinitions[gridPosition]
    }
}
