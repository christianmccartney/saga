//
//  EntityStatistic.swift
//  Saga
//
//  Created by Christian McCartney on 5/31/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import Foundation

final class EntityStatistics: Statistics {
    override var defaultStatisticTypes: [StatisticType] {
        [.strength, .dexterity, .constitution, .intelligence, .wisdom, .initiative, .movement]
    }
}
