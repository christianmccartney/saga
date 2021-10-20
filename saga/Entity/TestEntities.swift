//
//  TestEntities.swift
//  saga
//
//  Created by Christian McCartney on 10/17/21.
//

import Foundation

let fighterStats: EntityStatistics = EntityStatistics(
    [Statistic(.strength, 16),
     Statistic(.dexterity, 16),
     Statistic(.constitution, 16),
     Statistic(.intelligence, 10),
     Statistic(.wisdom, 10),
     Statistic(.initiative, 5)])
let jellyStats: EntityStatistics = EntityStatistics(
    [Statistic(.strength, 12),
     Statistic(.dexterity, 8),
     Statistic(.constitution, 20),
     Statistic(.intelligence, 3),
     Statistic(.wisdom, 3),
     Statistic(.initiative, 2)])
let archerStats: EntityStatistics = EntityStatistics(
    [Statistic(.strength, 12),
     Statistic(.dexterity, 18),
     Statistic(.constitution, 14),
     Statistic(.intelligence, 10),
     Statistic(.wisdom, 12),
     Statistic(.initiative, 6)])
let catStats: EntityStatistics = EntityStatistics(
    [Statistic(.strength, 8),
     Statistic(.dexterity, 20),
     Statistic(.constitution, 8),
     Statistic(.intelligence, 6),
     Statistic(.wisdom, 12),
     Statistic(.initiative, 4)])
let druidStats: EntityStatistics = EntityStatistics(
    [Statistic(.strength, 10),
     Statistic(.dexterity, 16),
     Statistic(.constitution, 10),
     Statistic(.intelligence, 14),
     Statistic(.wisdom, 18),
     Statistic(.initiative, 2)])

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
