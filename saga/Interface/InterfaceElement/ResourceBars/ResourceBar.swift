//
//  ResourceBar.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SpriteKit

enum ResourceBar: String, CaseIterable {
    case fullHealth = "td_interface_hp_full_"
    case emptyHealth = "td_interface_hp_empty_"
    case fullMana = "td_interface_mp_full_"
    case emptyMana = "td_interface_mp_empty_"

    private static var textures: [ResourceBar: [SKTexture]] {
        var textures = [ResourceBar: [SKTexture]]()
        for textureName in ResourceBar.allCases {
            let texture1 = SKTexture(imageNamed: textureName.rawValue + "1")
            let texture2 = SKTexture(imageNamed: textureName.rawValue + "2")
            let texture3 = SKTexture(imageNamed: textureName.rawValue + "3")
            texture1.filteringMode = .nearest
            texture2.filteringMode = .nearest
            texture3.filteringMode = .nearest
            textures[textureName] = [texture1, texture2, texture3]
        }
        return textures
    }

    func textures() -> [SKTexture] {
        guard let textures = ResourceBar.textures[self] else {
            fatalError("Could not get texture for resource bar type \(self)")
        }
        return textures
    }
}
