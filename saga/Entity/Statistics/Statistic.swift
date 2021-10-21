//
//  Statistic.swift
//  saga
//
//  Created by Christian McCartney on 10/19/21.
//

import Foundation

public enum StatisticType {
    case strength
    case dexterity
    case constitution
    case intelligence
    case wisdom
    case initiative
    case movement

    var defaultValue: Int {
        switch self {
        case .movement:
            return 1
        default:
            return 3
        }
    }
}

public struct Statistic {
    let statisticType: StatisticType
    var value: Int
    var modifier: Int

    public init(_ statisticType: StatisticType, _ value: Int, _ modifier: Int = 0) {
        self.statisticType = statisticType
        self.value = value
        self.modifier = modifier
    }

    public init(_ statisticType: StatisticType) {
        self.statisticType = statisticType
        self.value = statisticType.defaultValue
        self.modifier = 0
    }
}

extension Statistic: Equatable {}

open class Statistics: Sequence, IteratorProtocol {
    var count = 0
    var statistics: [Statistic]
    var defaultStatisticTypes: [StatisticType] { [] }

    public init(_ statistics: [Statistic] = []) {
        self.statistics = []
        var allStatistics = [Statistic]()
        for statisticType in defaultStatisticTypes {
            allStatistics.append(statistics.first { $0.statisticType == statisticType } ?? Statistic(statisticType))
        }
        self.statistics = allStatistics
    }
    
    func checkStat(_ stat: StatisticType) -> Int {
        return statistics.first { $0.statisticType == stat }?.value ?? stat.defaultValue
    }

    public func next() -> Statistic? {
        while count < statistics.count {
            defer { count += 1}
            return statistics[count]
        }
        return nil
    }
}
