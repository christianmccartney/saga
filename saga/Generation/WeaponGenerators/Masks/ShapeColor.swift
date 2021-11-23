//
//  ShapeColor.swift
//  saga
//
//  Created by Christian McCartney on 11/23/21.
//

enum GemColor: CaseIterable {
    case blue
    case red
    case green
    case purple
    
    var color: PixelRGBU8 {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
}

enum ShapeColor {
    case clear
    case metal
    case metalAccent1
    case metalAccent2
    case gold
    case wood
    case woodAccent
    case gem([GemColor])
    
    var color: PixelRGBU8 {
        switch self {
        case .clear:
            return .clear
        case .metal:
            return .gray
        case .metalAccent1:
            return .lGray
        case .metalAccent2:
            return .dGray
        case .gold:
            return .yellow
        case .wood:
            return .dYellow
        case .woodAccent:
            return .black
        case .gem(let colors):
            return colors.randomElement()?.color ?? .black
        }
    }
}
