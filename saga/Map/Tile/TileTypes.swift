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
        return [("wall_\(self.rawValue)_h_a", 10),
                ("wall_\(self.rawValue)_h_b", 2),
                ("wall_\(self.rawValue)_h_c", 1),
                ("wall_\(self.rawValue)_h_crack", 1),
                ("wall_\(self.rawValue)_h_d", 1),
                ("wall_\(self.rawValue)_h_e", 0),]
    }
}

enum TileVerticalWallType: String {
    case stone
    case cave
    case sewer
    case crypt
    
    func textureNames() -> [(String, Int)] {
        return [("wall_\(self.rawValue)_v_a", 10),
                ("wall_\(self.rawValue)_v_b", 2),
                ("wall_\(self.rawValue)_v_c", 1),
                ("wall_\(self.rawValue)_v_crack", 1),
                ("wall_\(self.rawValue)_v_d", 1),
                ("wall_\(self.rawValue)_v_e", 0),]
    }
}

enum TileFloorType: String {
    case cobble
    case cobble2
    case dirt
    
    func textureNames() -> [(String, Int)] {
        return [("floor_\(self.rawValue)_a", 2),
                ("floor_\(self.rawValue)_b", 2),
                ("floor_\(self.rawValue)_c", 2),
                ("floor_\(self.rawValue)_d", 1),
                ("floor_\(self.rawValue)_e", 1),
                ("floor_\(self.rawValue)_f", 1),]
    }
}
