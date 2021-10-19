//
//  EntityStatistic.swift
//  Saga
//
//  Created by Christian McCartney on 5/31/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import Foundation

public struct EntityStatistic {
    let statistic: Statistic
    var value: Int
    var modifier: Int

    public init(_ statistic: Statistic, _ value: Int, _ modifier: Int = 0) {
        self.statistic = statistic
        self.value = value
        self.modifier = modifier
    }
}

public enum Statistic {
    case strength
    case dexterity
    case constitution
    case intelligence
    case wisdom
    case initiative
}
