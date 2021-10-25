//
//  Statistic.swift
//  saga
//
//  Created by Christian McCartney on 10/19/21.
//

import Foundation
import Combine

public enum StatisticType: String {
    case strength = "str"
    case dexterity = "dex"
    case constitution = "con"
    case intelligence = "int"
    case wisdom = "wis"
    case initiative = "initiative"
    case movement = "movement"

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

    func get() -> Int {
        switch statisticType {
        case .initiative:
            return value + modifier
        case .movement:
            return value + modifier
        default:
            return Int(floor((Float(value) + Float(modifier)) - 10) / 2)
        }
    }
}

extension Statistic: Equatable {}

open class Statistics: Sequence, IteratorProtocol, ObservableObject {
    var health: Float = 1.0
    var maxHealth: Float = 1.0
    var mana: Float = 0.0
    var maxMana: Float = 0.0
    var count = 0
    var statistics: [Statistic]
    var defaultStatisticTypes: [StatisticType] { [] }

    public init(_ statistics: [Statistic] = []) {
        self.statistics = []
        var allStatistics = [Statistic]()
        for statisticType in defaultStatisticTypes {
            let statistic = statistics.first(where: { $0.statisticType == statisticType }) ?? Statistic(statisticType)
            allStatistics.append(statistic)
            switch statisticType {
            case .constitution:
                health = Float(statistic.value + statistic.value)
                maxHealth = Float(statistic.value + statistic.value)
            case .intelligence:
                mana = Float(statistic.value + statistic.value)
                maxMana = Float(statistic.value + statistic.value)
            default:
                break
            }
        }
        self.statistics = allStatistics
    }
    
    func checkStat(_ stat: StatisticType) -> Int {
        return statistics.first { $0.statisticType == stat }?.value ?? stat.defaultValue
    }

    func checkModifier(_ stat: StatisticType) -> Int {
        return statistics.first { $0.statisticType == stat }?.get() ?? 0
    }

    public func next() -> Statistic? {
        while count < statistics.count {
            defer { count += 1 }
            return statistics[count]
        }
        return nil
    }
}

extension Statistics: CustomStringConvertible {
    public var description: String {
        var str = ""
        for stat in statistics {
            str.append("\(stat.statisticType.rawValue): \(stat.value) \(stat.modifier < 0 ? "-" : "+") \(stat.modifier)\n")
        }
        return str
    }
    
    public var inspectorDescription: String {
        var str = ""
        for stat in statistics {
            str.append("\(stat.statisticType.rawValue):\(stat.value)\(stat.modifier < 0 ? "-" : "+")\(stat.modifier)\n")
        }
        return str
    }
}
