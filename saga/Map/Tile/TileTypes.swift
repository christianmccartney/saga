//
//  TileTypes.swift
//  saga
//
//  Created by Christian McCartney on 10/15/21.
//

import Foundation

enum TileHorizontalWallType: String {
    case stone
    case cave
    case sewer
    case crypt

    func textureNames() -> [(String, Int)] {
        return [("td_world_wall_\(self.rawValue)_h_a", 10),
                ("td_world_wall_\(self.rawValue)_h_b", 2),
                ("td_world_wall_\(self.rawValue)_h_c", 1),
                ("td_world_wall_\(self.rawValue)_h_crack", 1),
                ("td_world_wall_\(self.rawValue)_h_d", 1),
                ("td_world_wall_\(self.rawValue)_h_e", 0),]
    }
}

enum TileVerticalWallType: String {
    case stone
    case cave
    case sewer
    case crypt
    
    func textureNames() -> [(String, Int)] {
        return [("td_world_wall_\(self.rawValue)_v_a", 10),
                ("td_world_wall_\(self.rawValue)_v_b", 2),
                ("td_world_wall_\(self.rawValue)_v_c", 1),
                ("td_world_wall_\(self.rawValue)_v_crack", 1),
                ("td_world_wall_\(self.rawValue)_v_d", 1),
                ("td_world_wall_\(self.rawValue)_v_e", 0),]
    }
}

enum TileFloorType: String {
    case cobble
    case cobble2
    case dirt
    
    func textureNames() -> [(String, Int)] {
        return [("td_world_floor_\(self.rawValue)_a", 2),
                ("td_world_floor_\(self.rawValue)_b", 2),
                ("td_world_floor_\(self.rawValue)_c", 2),
                ("td_world_floor_\(self.rawValue)_d", 1),
                ("td_world_floor_\(self.rawValue)_e", 1),
                ("td_world_floor_\(self.rawValue)_f", 1),]
    }
}
