//
//  ObjectType.swift
//  Saga
//
//  Created by Christian McCartney on 5/25/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

public enum StaticObjectType: String, EntityType {
    case bed
    case blood_a
    case blood_b
    case blood_bone
    case blood_c
    case blood_d
    case bookshelf_a
    case bookshelf_b
    case campfire_stones
    case cauldron
    case chair
    case chest
    case crate
    case floor_carpet_a
    case floor_carpet_b
    case floor_carpet_c
    case floor_carpet_d
    case floor_carpet_e
    case grass_a
    case grass_b
    case grass_c
    case grass_d
    case grass_e
    case grass_root_a
    case grass_root_b
    case grass_root_c
    case grass_root_d
    case grass_root_e
    case level_right
    case level_left
    case magic_circle_a
    case magic_circle_b
    case magic_circle_c
    case magic_circle_d
    case magic_circle_e
    case mushroom_pink
    case mushroom_red
    case mushroom_yellow
    case scorch_a
    case shrub_a
    case shrub_b
    case sign_blank
    case sign_inn
    case sign_potions
    case sign_weapons
    case slab_a
    case slab_b
    case slab_left
    case slab_middle
    case slab_right
    case stalagmite_a
    case stalagmite_b
    case statue_tentacle
    case statue_warrior
    case statue_winged
    case stone_cave
    case stone_grey
    case table_left
    case table_left_chair
    case table_middle
    case table_middle_paper
    case table_right
    case table_right_chair
    case table
    case throne_evil
    case throne_wood
    case tombstone_broken
    case tombstone
    case trap
    case urns_a
    case urns_b
    case urns_c
    case web_ne
    case web_nw
    case web_se
    case web_sw
    case web
}

public enum DynamicObjectType: String, EntityType {
    case campfire

    case candles_a
    case candles_b
    case candles_c

    case lilypad_a
    case lilypad_b
    case lilypad_c
    case lilypad_d

    case torch_light
    case torch
}
