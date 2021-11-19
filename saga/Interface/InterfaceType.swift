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
        return ["td_interface_panel_\(self.rawValue)_1",
                "td_interface_panel_\(self.rawValue)_2",
                "td_interface_panel_\(self.rawValue)_3",
                "td_interface_panel_\(self.rawValue)_4",
                "td_interface_panel_\(self.rawValue)_5",
                "td_interface_panel_\(self.rawValue)_6",
                "td_interface_panel_\(self.rawValue)_7",
                "td_interface_panel_\(self.rawValue)_8",
                "td_interface_panel_\(self.rawValue)_9",]
    }
}
