//
//  SwordBlueprint.swift
//  saga
//
//  Created by Christian McCartney on 10/29/21.
//

import CoreGraphics

struct SwordBlueprints {
    static let straightBlade: Blueprint = Blueprint(origin: CGPoint(x: 0.05, y: 0.5),
                                                    shapes: [TriangleMask(a: CGPoint(x: 0.025, y: 0.5),
                                                                          b: CGPoint(x: 0.15, y: 0.55),
                                                                          c: CGPoint(x: 0.15, y: 0.45)),
                                                             RectangleMask(a: CGPoint(x: 0.15, y: 0.45),
                                                                           b: CGPoint(x: 0.65, y: 0.55))])
    
    static let straightCrossguard: Blueprint = Blueprint(origin: CGPoint(x: 0.5, y: 0.3),
                                                         shapes: [RectangleMask(a: CGPoint(x: 0.65, y: 0.4),
                                                                                b: CGPoint(x: 0.7, y: 0.6))])

    static let straightHilt: Blueprint = Blueprint(origin: CGPoint(x: 0.6, y: 0.4),
                                                   shapes: [RectangleMask(a: CGPoint(x: 0.7, y: 0.475),
                                                                          b: CGPoint(x: 0.9, y: 0.525))])

    static let straightPommel: Blueprint = Blueprint(origin: CGPoint(x: 0.8, y: 0.3),
                                                     shapes: [RectangleMask(a: CGPoint(x: 0.8, y: 0.3),
                                                                            b: CGPoint(x: 0.9, y: 0.6))])
    
    static func blueprint(for component: WeaponComponent, form: WeaponForm) -> Blueprint {
        switch form {
        case .straight:
            switch component {
            case .blade:
                return SwordBlueprints.straightBlade
            case .crossguard:
                return SwordBlueprints.straightCrossguard
            case .hilt:
                return SwordBlueprints.straightHilt
            case .pommel:
                return SwordBlueprints.straightPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .parabolic:
            break
        case .cubic:
            break
        case .wavy:
            break
        case .twopronged:
            break
        case .threepronged:
            break
        }
        return SwordBlueprints.straightBlade
    }
}
