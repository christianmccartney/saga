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
            return "option_equip"
        case .arrow_up:
            return "option_go"
        case .arrow_right:
            return "option_go_right"
        case .bag:
            return "option_bag"
        case .blank:
            return "option_blank"
        case .cancel:
            return "option_cancel"
        case .close_stone:
            return "close_stone"
        case .close_scroll:
            return "close_scroll"
        case .circle:
            return "option_magic"
        case .exclamation:
            return "option_alert"
        case .potion:
            return "option_item"
        case .questionmark:
            return "option_setting"
        case .shield:
            return "option_defend"
        case .sword:
            return "option_attack"
        }
        
    }
}

public enum CursorType: String {
    case arrow = "cursor_arrow_"
    case crosshair = "cursor_crosshair_"
    case crosshair2 = "cursor_crosshair2_"
    case finger = "cursor_finger_"
    case grab = "cursor_grab_"
    case hand = "cursor_hand_"
    case magnify = "cursor_magnify_"
    case pointer = "cursor_pointer_"
    case redo = "cursor_redo_"
    case reduce = "cursor_reduce_"
    case target = "cursor_target_"
    case triangle = "cursor_triangle_"
    case undo = "cursor_undo_"
    case watch = "cursor_watch_"
}
