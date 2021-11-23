//
//  InterfaceType.swift
//  saga
//
//  Created by Christian McCartney on 10/16/21.
//

import Foundation
import SpriteKit

struct InterfaceTileGroupDefinition: AdjacencyTileGroupDefinition {
    let name: String
    let adjacencyTextureProvider: AdjacencyTextureProviding
}

enum InterfaceType: String, AdjacencyTextureProviding {
    case stone_a
    case stone_b
    case window
    case scroll_a
    case scroll_b
    case bubble

    var textures: [String] {
        return ["panel_\(self.rawValue)_1",
                "panel_\(self.rawValue)_2",
                "panel_\(self.rawValue)_3",
                "panel_\(self.rawValue)_4",
                "panel_\(self.rawValue)_5",
                "panel_\(self.rawValue)_6",
                "panel_\(self.rawValue)_7",
                "panel_\(self.rawValue)_8",
                "panel_\(self.rawValue)_9",]
    }
}
