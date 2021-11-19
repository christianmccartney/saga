//
//  ButtonType.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

enum ButtonType {
    case ability(Ability)
    case armor
    case arrow_up
    case arrow_right
    case bag
    case blank
    case cancel
    case close_stone
    case close_scroll
    case circle
    case exclamation
    case potion
    case questionmark
    case shield
    case sword
    
    var textureName: String {
        switch self {
        case .ability(let ability):
            return ability.abilityTextureName
        case .armor:
            return "td_interface_option_equip"
        case .arrow_up:
            return "td_interface_option_go"
        case .arrow_right:
            return "td_interface_option_go_right"
        case .bag:
            return "td_interface_option_bag"
        case .blank:
            return "td_interface_option_blank"
        case .cancel:
            return "td_interface_option_cancel"
        case .close_stone:
            return "td_interface_close_stone"
        case .close_scroll:
            return "td_interface_close_scroll"
        case .circle:
            return "td_interface_option_magic"
        case .exclamation:
            return "td_interface_option_alert"
        case .potion:
            return "td_interface_option_item"
        case .questionmark:
            return "td_interface_option_setting"
        case .shield:
            return "td_interface_option_defend"
        case .sword:
            return "td_interface_option_attack"
        }
        
    }
}

public enum CursorType: String {
    case arrow = "td_interface_cursor_arrow_"
    case crosshair = "td_interface_cursor_crosshair_"
    case crosshair2 = "td_interface_cursor_crosshair2_"
    case finger = "td_interface_cursor_finger_"
    case grab = "td_interface_cursor_grab_"
    case hand = "td_interface_cursor_hand_"
    case magnify = "td_interface_cursor_magnify_"
    case pointer = "td_interface_cursor_pointer_"
    case redo = "td_interface_cursor_redo_"
    case reduce = "td_interface_cursor_reduce_"
    case target = "td_interface_cursor_target_"
    case triangle = "td_interface_cursor_triangle_"
    case undo = "td_interface_cursor_undo_"
    case watch = "td_interface_cursor_watch_"
}
