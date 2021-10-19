//
//  SelectionType.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

public enum SelectionType: String, CaseIterable, EntityType {
    case green_entity_select1 = "tiny_dungeon_interface_select_a1"
    case green_entity_select2 = "tiny_dungeon_interface_select_a2"
    case green_highlight1 = "tiny_dungeon_interface_select_b1"
    case green_highlight2 = "tiny_dungeon_interface_select_b2"
    case green_crosshair1 = "tiny_dungeon_interface_select_c1"
    case green_crosshair2 = "tiny_dungeon_interface_select_c2"

    case red_entity_select1 = "tiny_dungeon_interface_select_d1"
    case red_entity_select2 = "tiny_dungeon_interface_select_d2"
    case red_highlight1 = "tiny_dungeon_interface_select_e1"
    case red_highlight2 = "tiny_dungeon_interface_select_e2"
    case red_crosshair1 = "tiny_dungeon_interface_select_f1"
    case red_crosshair2 = "tiny_dungeon_interface_select_f2"

    case yellow_entity_select1 = "tiny_dungeon_interface_select_g1"
    case yellow_entity_select2 = "tiny_dungeon_interface_select_g2"
    case yellow_highlight1 = "tiny_dungeon_interface_select_h1"
    case yellow_highlight2 = "tiny_dungeon_interface_select_h2"
    case yellow_crosshair1 = "tiny_dungeon_interface_select_i1"
    case yellow_crosshair2 = "tiny_dungeon_interface_select_i2"
}
