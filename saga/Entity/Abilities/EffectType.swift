//
//  EffectType.swift
//  saga
//
//  Created by Christian McCartney on 11/14/21.
//

import Foundation
import SpriteKit

enum EffectType: String, CaseIterable {
    case none = ""
    case fireball = "tiny_dungeon_fx_fireball"
    case iceball = "tiny_dungeon_fx_iceball"
    case voidball = "tiny_dungeon_fx_voidball"

    static var textures: [EffectType: SKTexture] {
        var textures = [EffectType: SKTexture]()
        for effectType in EffectType.allCases {
            textures[effectType] = SKTexture(imageNamed: effectType.rawValue)
        }
        return textures
    }
}

enum AnimatedEffect: String, CaseIterable {
    case fireImpact = "tiny_dungeon_fx_fireimpact_"
    case iceImpact = "tiny_dungeon_fx_iceimpact_"
    case voidImpact = "tiny_dungeon_fx_voidimpact_"
    case bloodImpact = "tiny_dungeon_fx_blood_"
    case slash1 = "tiny_dungeon_fx_slash_"
    case slash2 = "tiny_dungeon_fx_slash2_"
    case cut = "tiny_dungeon_fx_cut_"
    case sparkle = "tiny_dungeon_fx_sparkle_"

    case fireSpark = "tiny_dungeon_fx_firespark_"
    case fireBurn = "tiny_dungeon_fx_fireburn_"
    case iceSpark = "tiny_dungeon_fx_icespark_"
    case iceBurn = "tiny_dungeon_fx_iceburn_"
    case voidSpark = "tiny_dungeon_fx_voidspark_"
    case voidBurn = "tiny_dungeon_fx_voidburn_"
    case smoke = "tiny_dungeon_fx_smoke_"
    
    static var textures: [AnimatedEffect: [SKTexture]] {
        var textures = [AnimatedEffect: [SKTexture]]()
        for animatedEffect in AnimatedEffect.allCases {
            switch animatedEffect {
            case .fireImpact, .iceImpact, .voidImpact, .bloodImpact, .slash1, .slash2, .cut, .sparkle:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "2"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "3")]
            case .fireSpark, .fireBurn, .iceSpark, .iceBurn, .voidSpark, .voidBurn, .smoke:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "2")]
            }
            textures[animatedEffect]?.forEach { $0.filteringMode = .nearest }
        }
        
        return textures
    }
}
