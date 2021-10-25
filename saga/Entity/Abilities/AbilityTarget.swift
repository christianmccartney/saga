//
//  AbilityTarget.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SpriteKit

enum AbilityTarget {
    case caster
    case friendly
    case neutral
    case enemy

    func checkAvailable(casting: EntityFaction, target: EntityFaction) -> Bool {
        switch (casting, target) {
        case (.player, .player):
            return self == .caster
        case (.player, .friendly):
            return self == .friendly
        case (.friendly, .player):
            return self == .friendly
        case (.player, .neutral):
            return self == .neutral
        case (.neutral, .player):
            return self == .neutral
        case (.player, .enemy):
            return self == .enemy
        case (.enemy, .player):
            return self == .enemy
        default:
            return false
        }
    }

    func texture() -> SKTexture? {
        switch self {
        case .caster:
            return nil
        case .friendly:
            return SelectionType.green_crosshair2.texture()
        case .neutral:
            return SelectionType.yellow_crosshair2.texture()
        case .enemy:
            return SelectionType.red_crosshair2.texture()
        }
    }
}
