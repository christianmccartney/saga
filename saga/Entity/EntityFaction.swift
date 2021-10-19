//
//  EntityFaction.swift
//  Saga
//
//  Created by Christian McCartney on 5/25/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

public enum EntityFaction: Int {
    case player = 0
    case friendly = 1
    case neutral = 2
    case enemy = 3

    func isHostileTo(_ faction: EntityFaction) -> Bool {
        switch self {
        case .player:
            return faction == .enemy
        case .friendly:
            return faction == .enemy
        case .neutral:
            return false
        case .enemy:
            return faction == .player || faction == .friendly
        }
    }
}
