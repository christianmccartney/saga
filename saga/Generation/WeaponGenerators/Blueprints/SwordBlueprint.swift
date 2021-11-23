//
//  SwordBlueprint.swift
//  saga
//
//  Created by Christian McCartney on 10/29/21.
//

import CoreGraphics

// y lower = up
// y higher = down

struct SwordBlueprints {
    
    // MARK: No components
//    static let noCrossguard = Blueprint(
//        origin: CGPoint(x: 0.62, y: 0.5),
//        z: 1,
//        shapes: [RectangleMask(a: CGPoint(x: 0.65, y: 0.4),
//                               b: CGPoint(x: 0.7, y: 0.6))])
    
    // MARK: Straight components
    private static let straightHiltWidth = 0.02
    static let straightBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 0,
        shapes: [TriangleMask(a: CGPoint(x: 0.06, y: 0.5),
                              b: CGPoint(x: 0.15, y: 0.53),
                              c: CGPoint(x: 0.15, y: 0.47),
                              z: 0,
                              color: .metal),
                 RectangleMask(a: CGPoint(x: 0.15, y: 0.47),
                               b: CGPoint(x: 0.67, y: 0.53),
                               z: 0,
                               color: .metal)])
    
    static let straightCrossguard = Blueprint(
        origin: CGPoint(x: 0.62, y: 0.5),
        z: 1,
        shapes: [RectangleMask(a: CGPoint(x: 0.66, y: 0.43),
                               b: CGPoint(x: 0.69, y: 0.57),
                               z: 0,
                               color: .wood)])

    static let straightHilt = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 0,
        shapes: [RectangleMask(a: CGPoint(x: 0.68, -straightHiltWidth),
                               b: CGPoint(x: 0.9, straightHiltWidth),
                               z: 0,
                               color: .wood)])

    static let straightPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [CircleMask(center: CGPoint(x: 0.92, y: 0.5),
                            radius: 0.04,
                            z: 0,
                            color: .metal)])
    
    // MARK: Parabolic components
    static let parabolicBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 0,
        shapes: [BezierMask(start: CGPoint(x: 0.67, y: 0.46),
                            points: [(CGPoint(x: 0.15, y: 0.43), CGPoint(x: 0.4, y: 0.55)),
                                     (CGPoint(x: 0.15, y: 0.46), nil),
                                     (CGPoint(x: 0.67, y: 0.54), CGPoint(x: 0.4, y: 0.63)),
                                    ],
                            color: .metal)])
    
    static let parabolicCrossguard = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.61, y: 0.37),
                            points: [(CGPoint(x: 0.61, y: 0.63), CGPoint(x: 0.7, y: 0.5)),
                                     (CGPoint(x: 0.63, y: 0.63), nil),
                                     (CGPoint(x: 0.63, y: 0.37), CGPoint(x: 0.78, y: 0.5)),
                                     (CGPoint(x: 0.61, y: 0.37), nil),
                                    ],
                            color: .gold)])
    
    static let parabolicHilt = Blueprint(
        origin: CGPoint(x: 0.7, y: 0.5),
        z: 0,
        shapes: [BezierMask(start: CGPoint(x: 0.69, y: 0.47),
                            points: [(CGPoint(x: 0.9, y: 0.47), CGPoint(x: 0.8, y: 0.43)),
                                     (CGPoint(x: 0.9, y: 0.53), nil),
                                     (CGPoint(x: 0.69, y: 0.53), CGPoint(x: 0.8, y: 0.48)),
                                     (CGPoint(x: 0.69, y: 0.47), nil),
                                    ],
                            color: .wood)])
    
    static let parabolicPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.94, y: 0.57),
                            points: [(CGPoint(x: 0.94, y: 0.43), CGPoint(x: 0.79, y: 0.5)),
                                     (CGPoint(x: 0.94, y: 0.45), nil),
                                     (CGPoint(x: 0.94, y: 0.55), CGPoint(x: 0.87, y: 0.5)),
                                     (CGPoint(x: 0.94, y: 0.57), nil),
                                    ],
                            color: .metal)])
    
    // MARK: Cubic components
    static let cubicBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 0,
        shapes: [BezierMask(start: CGPoint(x: 0.66, y: 0.46),
                            points: [(CGPoint(x: 0.4, y: 0.46), CGPoint(x: 0.5, y: 0.4)),
                                     (CGPoint(x: 0.2, y: 0.46), CGPoint(x: 0.3, y: 0.52)),
                                     (CGPoint(x: 0.1, y: 0.41), nil),
                                     (CGPoint(x: 0.12, y: 0.45), nil),
                                     (CGPoint(x: 0.2, y: 0.54), nil),
                                     (CGPoint(x: 0.4, y: 0.54), CGPoint(x: 0.3, y: 0.6)),
                                     (CGPoint(x: 0.66, y: 0.54), CGPoint(x: 0.5, y: 0.48)),
                                    ],
                            color: .metal)])
    
    static let cubicCrossguard = Blueprint(
        origin: CGPoint(x: 0.65, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.67, y: 0.37),
                            points: [(CGPoint(x: 0.65, y: 0.5), CGPoint(x: 0.62, y: 0.43)),
                                     (CGPoint(x: 0.67, y: 0.63), CGPoint(x: 0.69, y: 0.57)),
                                     (CGPoint(x: 0.68, y: 0.63), nil),
                                     (CGPoint(x: 0.70, y: 0.5), CGPoint(x: 0.73, y: 0.57)),
                                     (CGPoint(x: 0.68, y: 0.37), CGPoint(x: 0.66, y: 0.43)),
                                    ],
                            color: .gold)])
    
    static let cubicHilt = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 0,
        shapes: [RectangleMask(a: CGPoint(x: 0.68, -straightHiltWidth),
                               b: CGPoint(x: 0.9, straightHiltWidth),
                               z: 0,
                               color: .wood),
                 RectangleMask(a: CGPoint(x: 0.68, -straightHiltWidth),
                               b: CGPoint(x: 0.72, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 RectangleMask(a: CGPoint(x: 0.75, -straightHiltWidth),
                               b: CGPoint(x: 0.77, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 RectangleMask(a: CGPoint(x: 0.8, -straightHiltWidth),
                               b: CGPoint(x: 0.82, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 RectangleMask(a: CGPoint(x: 0.85, -straightHiltWidth),
                               b: CGPoint(x: 0.87, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 ])
    
    static let cubicPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.94, y: 0.57),
                            points: [(CGPoint(x: 0.94, y: 0.43), CGPoint(x: 0.79, y: 0.5)),
                                     (CGPoint(x: 0.94, y: 0.45), nil),
                                     (CGPoint(x: 0.94, y: 0.55), CGPoint(x: 0.87, y: 0.5)),
                                     (CGPoint(x: 0.94, y: 0.57), nil),
                                    ],
                            color: .metal),
                 CircleMask(center: CGPoint(x: 0.92, y: 0.5),
                            radius: 0.03,
                            z: 1,
                            color: .gem([.green, .purple]))
                ])

    // MARK: Wavy components
    static let wavyBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 0,
        shapes: [BezierMask(start: CGPoint(x: 0.66, y: 0.47),
                            points: [(CGPoint(x: 0.5, y: 0.47), CGPoint(x: 0.55, y: 0.5)),
                                     (CGPoint(x: 0.4, y: 0.47), CGPoint(x: 0.45, y: 0.44)),
                                     (CGPoint(x: 0.3, y: 0.47), CGPoint(x: 0.35, y: 0.5)),
                                     (CGPoint(x: 0.16, y: 0.47), nil),
                                     (CGPoint(x: 0.16, y: 0.53), nil),
                                     (CGPoint(x: 0.3, y: 0.53), nil),
                                     (CGPoint(x: 0.4, y: 0.53), CGPoint(x: 0.35, y: 0.56)),
                                     (CGPoint(x: 0.5, y: 0.53), CGPoint(x: 0.45, y: 0.50)),
                                     (CGPoint(x: 0.66, y: 0.53), CGPoint(x: 0.55, y: 0.56)),
                                    ],
                            color: .metal),
                 TriangleMask(a: CGPoint(x: 0.05, y: 0.5),
                              b: CGPoint(x: 0.16, y: 0.53),
                              c: CGPoint(x: 0.16, y: 0.47),
                              z: 0,
                              color: .metal),])
    
    static let wavyCrossguard = Blueprint(
        origin: CGPoint(x: 0.65, y: 0.5),
        z: 1,
        shapes: [BezierMask(start: CGPoint(x: 0.66, y: 0.37),
                            points: [(CGPoint(x: 0.63, y: 0.5), CGPoint(x: 0.68, y: 0.43)),
                                     (CGPoint(x: 0.66, y: 0.63), CGPoint(x: 0.68, y: 0.57)),
                                     (CGPoint(x: 0.67, y: 0.63), nil),
                                     (CGPoint(x: 0.7, y: 0.5), CGPoint(x: 0.72, y: 0.57)),
                                     (CGPoint(x: 0.67, y: 0.37), CGPoint(x: 0.72, y: 0.43)),
                                    ],
                            color: .gold)])
    

    static let wavyHilt = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 0,
        shapes: [RectangleMask(a: CGPoint(x: 0.68, -straightHiltWidth),
                               b: CGPoint(x: 0.9, straightHiltWidth),
                               z: 0,
                               color: .gold),
                 RectangleMask(a: CGPoint(x: 0.68, -straightHiltWidth),
                               b: CGPoint(x: 0.72, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 RectangleMask(a: CGPoint(x: 0.75, -straightHiltWidth),
                               b: CGPoint(x: 0.77, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 RectangleMask(a: CGPoint(x: 0.8, -straightHiltWidth),
                               b: CGPoint(x: 0.82, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                 RectangleMask(a: CGPoint(x: 0.85, -straightHiltWidth),
                               b: CGPoint(x: 0.87, straightHiltWidth),
                               z: 1,
                               color: .woodAccent),
                ])
    
    static let wavyPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [CircleMask(center: CGPoint(x: 0.92, y: 0.5),
                            radius: 0.04,
                            z: 0,
                            color: .metal),
                 CircleMask(center: CGPoint(x: 0.92, y: 0.5),
                                     radius: 0.02,
                                     z: 1,
                            color: .gem([.red, .blue]))
                ])
    
    // MARK: Two pronged components
    private static let twoProngedBladeWidth = 0.03
    private static let twoProngedBladeUpperY = -0.02
    private static let twoProngedBladeLowerY = 0.02
    
    static let twoProngedBlade = Blueprint(
        origin: CGPoint(x: 0.05, y: 0.5),
        z: 0,
        shapes: [TriangleMask(a: CGPoint(x: 0.05, twoProngedBladeLowerY),
                              b: CGPoint(x: 0.16, twoProngedBladeLowerY),
                              c: CGPoint(x: 0.16, twoProngedBladeLowerY + twoProngedBladeWidth),
                              z: 0,
                              color: .metal),
                 RectangleMask(a: CGPoint(x: 0.15, twoProngedBladeLowerY + twoProngedBladeWidth),
                               b: CGPoint(x: 0.67, twoProngedBladeLowerY),
                               z: 0,
                               color: .metal),
                 TriangleMask(a: CGPoint(x: 0.05, twoProngedBladeUpperY),
                              b: CGPoint(x: 0.16, twoProngedBladeUpperY),
                              c: CGPoint(x: 0.16, twoProngedBladeUpperY - twoProngedBladeWidth),
                              z: 0,
                              color: .metal),
                 RectangleMask(a: CGPoint(x: 0.15, twoProngedBladeUpperY - twoProngedBladeWidth),
                               b: CGPoint(x: 0.67, twoProngedBladeUpperY),
                               z: 0,
                               color: .metal),
                 RectangleMask(a: CGPoint(x: 0.65, -0.02),
                               b: CGPoint(x: 0.67, 0.02),
                               z: 0,
                               color: .metal),
                ])
    
    
    static let twoProngedCrossguard = Blueprint(
        origin: CGPoint(x: 0.65, y: 0.5),
        z: 1,
        shapes: [TriangleMask(a: CGPoint(x: 0.63, 0.0),
                              b: CGPoint(x: 0.7, 0.08),
                              c: CGPoint(x: 0.7, -0.08),
                              z: 0,
                              color: .gold),
                 ])

    private static let twoProngedHiltdyU: CGFloat = -0.025
    private static let twoProngedHiltdyD: CGFloat = 0.025
    static let twoProngedHilt = Blueprint(
        origin: CGPoint(x: 0.6, y: 0.5),
        z: 0,
        shapes: [RectangleMask(a: CGPoint(x: 0.68, twoProngedHiltdyU),
                               b: CGPoint(x: 0.9, twoProngedHiltdyD),
                               z: 0,
                               color: .wood),
                 TriangleMask(a: CGPoint(x: 0.68, twoProngedHiltdyU),
                              b: CGPoint(x: 0.72, twoProngedHiltdyU),
                              c: CGPoint(x: 0.72, twoProngedHiltdyD),
                              z: 1,
                              color: .woodAccent),
                 TriangleMask(a: CGPoint(x: 0.72, twoProngedHiltdyU),
                              b: CGPoint(x: 0.72, twoProngedHiltdyD),
                              c: CGPoint(x: 0.76, twoProngedHiltdyD),
                              z: 1,
                              color: .woodAccent),
                 TriangleMask(a: CGPoint(x: 0.75, twoProngedHiltdyU),
                              b: CGPoint(x: 0.79, twoProngedHiltdyU),
                              c: CGPoint(x: 0.79, twoProngedHiltdyD),
                              z: 1,
                              color: .woodAccent),
                 TriangleMask(a: CGPoint(x: 0.79, twoProngedHiltdyU),
                              b: CGPoint(x: 0.79, twoProngedHiltdyD),
                              c: CGPoint(x: 0.83, twoProngedHiltdyD),
                              z: 1,
                              color: .woodAccent),
                 TriangleMask(a: CGPoint(x: 0.82, twoProngedHiltdyU),
                              b: CGPoint(x: 0.86, twoProngedHiltdyU),
                              c: CGPoint(x: 0.86, twoProngedHiltdyD),
                              z: 1,
                              color: .woodAccent),
                 TriangleMask(a: CGPoint(x: 0.86, twoProngedHiltdyU),
                              b: CGPoint(x: 0.86, twoProngedHiltdyD),
                              c: CGPoint(x: 0.9, twoProngedHiltdyD),
                              z: 1,
                              color: .woodAccent),
                ])
    
    static let twoProngedPommel = Blueprint(
        origin: CGPoint(x: 0.9, y: 0.5),
        z: 1,
        shapes: [TriangleMask(a: CGPoint(x: 0.96, 0.0),
                              b: CGPoint(x: 0.9, -0.05),
                              c: CGPoint(x: 0.9, 0.05),
                              z: 0,
                              color: .gold),
                 ])
    
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
            switch component {
            case .blade:
                return SwordBlueprints.parabolicBlade
            case .crossguard:
                return SwordBlueprints.parabolicCrossguard
            case .hilt:
                return SwordBlueprints.parabolicHilt
            case .pommel:
                return SwordBlueprints.parabolicPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .cubic:
            switch component {
            case .blade:
                return SwordBlueprints.cubicBlade
            case .crossguard:
                return SwordBlueprints.cubicCrossguard
            case .hilt:
                return SwordBlueprints.cubicHilt
            case .pommel:
                return SwordBlueprints.cubicPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .wavy:
            switch component {
            case .blade:
                return SwordBlueprints.wavyBlade
            case .crossguard:
                return SwordBlueprints.wavyCrossguard
            case .hilt:
                return SwordBlueprints.wavyHilt
            case .pommel:
                return SwordBlueprints.wavyPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .twopronged:
            switch component {
            case .blade:
                return SwordBlueprints.twoProngedBlade
            case .crossguard:
                return SwordBlueprints.twoProngedCrossguard
            case .hilt:
                return SwordBlueprints.twoProngedHilt
            case .pommel:
                return SwordBlueprints.twoProngedPommel
            default:
                print("Shouldnt have gotten here")
            }
        case .threepronged:
            break
        }
        return SwordBlueprints.straightBlade
    }
}

extension WeaponDefinition {
    static func randomSword() -> WeaponDefinition {
        let forms: [WeaponForm] = [.straight, .parabolic, .cubic, .wavy, .twopronged]
        let random = [WeaponComponentForm(component: .blade, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .crossguard, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .hilt, form: forms[Int.random(in: 0..<forms.count)]),
                      WeaponComponentForm(component: .pommel, form: forms[Int.random(in: 0..<forms.count)])]
        return WeaponDefinition(
            type: .sword,
            componentForms: Set(random),
            property: .simple)
    }
}
