//
//  EntityType.swift
//  Saga
//
//  Created by Christian McCartney on 5/25/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

public protocol EntityType { }

extension EntityType where Self: RawRepresentable, RawValue == String {
    var name: String {
        return self.rawValue
    }
}

public enum CreatureType: String, EntityType {
    case angel = "td_monsters_angel"
    case archer = "td_monsters_archer"
    case bat = "td_monsters_bat"
    case beetle = "td_monsters_beetle"
    case beholder = "td_monsters_beholder"
    case berserker = "td_monsters_berserker"
    case cat = "td_monsters_cat"
    case centaur = "td_monsters_centaur"
    case cleric = "td_monsters_cleric"
    case demon = "td_monsters_demon"
    case dragon = "td_monsters_dragon"
    case druid = "td_monsters_druid"
    case dwarf = "td_monsters_dwarf"
    case elemental = "td_monsters_elemental"
    case fighter = "td_monsters_fighter"
    case flame = "td_monsters_flame"
    case flies = "td_monsters_flies"
    case giant = "td_monsters_giant"
    case goblin_captain = "td_monsters_goblin_captain"
    case goblin_grunt = "td_monsters_grunt"
    case goblin_mage = "td_monsters_mage"
    case griffin = "td_monsters_griffin"
    case hobbit = "td_monsters_hobbit"
    case horse = "td_monsters_horse"
    case jelly = "td_monsters_jelly"
    case king = "td_monsters_king"
    case knight = "td_monsters_knight"
    case mercenary = "td_monsters_mercenary"
    case merchant = "td_monsters_merchant"
    case mimic = "td_monsters_mimic"
    case minotaur = "td_monsters_minotaur"
    case minstrel = "td_monsters_minstrel"
    case moth = "td_monsters_moth"
    case mummy = "td_monsters_mummy"
    case necromancer = "td_monsters_necromancer"
    case paladin = "td_monsters_paladin"
    case pheonix = "td_monsters_pheonix"
    case pixie = "td_monsters_pixie"
    case plant = "td_monsters_plant"
    case queen = "td_monsters_queen"
    case rat = "td_monsters_rat"
    case reaper = "td_monsters_reaper"
    case rogue = "td_monsters_rogue"
    case satyr = "td_monsters_satyr"
    case skeleton_lich = "td_monsters_skeleton_lich"
    case skeleton_mage = "td_monsters_skeleton_mage"
    case skeleton_unarmed = "td_monsters_skeleton_unarmed"
    case skeleton_warrior = "td_monsters_skeleton_warrior"
    case slime = "td_monsters_slime"
    case snake = "td_monsters_snake"
    case spider = "td_monsters_spider"
    case treant = "td_monsters_treant"
    case troll = "td_monsters_troll"
    case vampire = "td_monsters_vampire"
    case villager_girl = "td_monsters_villager_f"
    case villager_man = "td_monsters_villager_m"
    case void = "td_monsters_void"
    case witch = "td_monsters_witch"
    case wizard = "td_monsters_wizard"
    case wolf = "td_monsters_wolf"
    case wraith = "td_monsters_wraith"
    case yeti = "td_monsters_yeti"
    case zombie = "td_monsters_zombie"
}
