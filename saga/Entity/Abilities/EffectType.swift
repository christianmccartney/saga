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
    case fireball
    case iceball
    case voidball

    static var textures: [EffectType: SKTexture] {
        var textures = [EffectType: SKTexture]()
        for effectType in EffectType.allCases {
            textures[effectType] = SKTexture(imageNamed: effectType.rawValue)
        }
        return textures
    }
}

enum AnimatedEffect: String, CaseIterable {
    case fireimpact
    case iceimpact
    case voidimpact
    case blood
    case slash
    case slash2
    case cut
    case sparkle

    case firespark
    case fireburn
    case icespark
    case iceburn
    case voidspark
    case voidburn
    case smoke
    
    static var textures: [AnimatedEffect: [SKTexture]] {
        var textures = [AnimatedEffect: [SKTexture]]()
        for animatedEffect in AnimatedEffect.allCases {
            switch animatedEffect {
            case .fireimpact, .iceimpact, .voidimpact, .blood, .slash, .slash2, .cut, .sparkle:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "_1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "_2"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "_3")]
            case .firespark, .fireburn, .icespark, .iceburn, .voidspark, .voidburn, .smoke:
                textures[animatedEffect] = [
                    SKTexture(imageNamed: animatedEffect.rawValue + "_1"),
                    SKTexture(imageNamed: animatedEffect.rawValue + "_2")]
            }
            textures[animatedEffect]?.forEach { $0.filteringMode = .nearest }
        }
        
        return textures
    }
}
