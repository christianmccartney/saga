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
    case fireSpark = "tiny_dungeon_fx_firespark_"
    case voidImpact = "tiny_dungeon_fx_voidimpact_"
    case bloodImpact = "tiny_dungeon_fx_blood_"
    
    static var textures: [AnimatedEffect: [SKTexture]] {
        var textures = [AnimatedEffect: [SKTexture]]()
        for animatedEffect in AnimatedEffect.allCases {
            switch animatedEffect {
            case .fireImpact:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "2"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "3")]
            case .fireSpark:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "2")]
            case .bloodImpact:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "2"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "3")]
            case .voidImpact:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "2"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "3")]
            }
            textures[animatedEffect]?.forEach { $0.filteringMode = .nearest }
        }
        
        return textures
    }
}
