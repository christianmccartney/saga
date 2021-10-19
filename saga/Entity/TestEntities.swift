//
//  TestEntities.swift
//  saga
//
//  Created by Christian McCartney on 10/17/21.
//

import Foundation

let fighterStats: [EntityStatistic] = [EntityStatistic(.strength, 16),
                                       EntityStatistic(.dexterity, 16),
                                       EntityStatistic(.constitution, 16),
                                       EntityStatistic(.intelligence, 10),
                                       EntityStatistic(.wisdom, 10),
                                       EntityStatistic(.initiative, 5)]
let jellyStats: [EntityStatistic]   = [EntityStatistic(.strength, 12),
                                       EntityStatistic(.dexterity, 8),
                                       EntityStatistic(.constitution, 20),
                                       EntityStatistic(.intelligence, 3),
                                       EntityStatistic(.wisdom, 3),
                                       EntityStatistic(.initiative, 2)]
let archerStats: [EntityStatistic]  = [EntityStatistic(.strength, 12),
                                       EntityStatistic(.dexterity, 18),
                                       EntityStatistic(.constitution, 14),
                                       EntityStatistic(.intelligence, 10),
                                       EntityStatistic(.wisdom, 12),
                                       EntityStatistic(.initiative, 6)]
let catStats: [EntityStatistic]     = [EntityStatistic(.strength, 8),
                                       EntityStatistic(.dexterity, 20),
                                       EntityStatistic(.constitution, 8),
                                       EntityStatistic(.intelligence, 6),
                                       EntityStatistic(.wisdom, 12),
                                       EntityStatistic(.initiative, 4)]
let druidStats: [EntityStatistic]   = [EntityStatistic(.strength, 10),
                                       EntityStatistic(.dexterity, 16),
                                       EntityStatistic(.constitution, 10),
                                       EntityStatistic(.intelligence, 14),
                                       EntityStatistic(.wisdom, 18),
                                       EntityStatistic(.initiative, 2)]

// Entities
let fighterEntity = Creature(type: .fighter,
                             faction: .player,
                             position: Position(15, 10),
                             statistics: fighterStats)
let jellyEntity =   Creature(type: .jelly,
                             faction: .enemy,
                             position: Position(7, 6),
                             statistics: jellyStats)
let archerEntity =  Creature(type: .archer,
                             faction: .friendly,
                             direction: .right,
                             position: Position(6, 6),
                             statistics: archerStats)
let catEntity =     Creature(type: .cat,
                             position: Position(10, 10),
                             statistics: catStats)
let druidEntity =   Creature(type: .druid,
                             faction: .friendly,
                             position: Position(6, 10),
                             statistics: druidStats)
