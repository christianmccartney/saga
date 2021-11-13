//
//  WeaponGenerator.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import UIKit

// A - Apply: using the input apply a transformation
// C - Choose: randomly generate output from input
// G - Get: from the input get the assigned output
//
// +----------+                      +---------+
// |Definition|---Type,Property---G->|Transform|
// +----------+                      +---------+
//      |                                 |
//      |                                 A
//      |                                 |
//      |                                 v
//      |                +----+      +---------+
//      +---Property--C->|Form|---G->|Blueprint|
//                       +----+      +---------+

struct WeaponDefinition {
    let type: WeaponType
    let components: Set<WeaponComponent>
    let property: WeaponProperty
}

class WeaponGenerator {
    static let shared = WeaponGenerator()
    
    private init() {}

    func generateBlueprints(for definition: WeaponDefinition) -> [Blueprint] {
        var blueprints = [Blueprint]()
        for component in definition.components {
            blueprints.append(WeaponBlueprint.generate(for: definition.type,
                                                          component: component,
                                                          form: .straight))
        }
        return blueprints
    }

    func transform(definition: WeaponDefinition) -> WeaponTransform {
        // For the size properties just return a scale factor
        switch definition.property {
        case .cute:
            return WeaponTransform(xScale: 0.5, yScale: 0.5)
        case .normal:
            return WeaponTransform()
        case .large:
            return WeaponTransform(xScale: 1.25, yScale: 1.25)
        case .huge:
            return WeaponTransform(xScale: 1.5, yScale: 1.5)
        default:
            break
        }
        
        switch definition.type {
        case .sword:
            if definition.property == .broken {
                let triangleMask = TriangleMask(a: CGPoint(x: 0, y: 0),
                                                b: CGPoint(x: 1, y: 1),
                                                c: CGPoint(x: 1, y: 0))
                return WeaponTransform(masks: [.blade: triangleMask])
            }
            if definition.property == .halved {
                let rectangleMask = RectangleMask(a: CGPoint(x: 0, y: 0.5),
                                                  b: CGPoint(x: 1, y: 1))
                return WeaponTransform(masks: [.blade: rectangleMask,
                                               .crossguard: rectangleMask,
                                               .hilt: rectangleMask,
                                               .pommel: rectangleMask])
            }
        case .axe:
            if definition.property == .broken {
                let triangleMask = TriangleMask(a: CGPoint(x: 0, y: 0),
                                                b: CGPoint(x: 1, y: 0.75),
                                                c: CGPoint(x: 1, y: 0))
                return WeaponTransform(masks: [.blade: triangleMask])
            }
            if definition.property == .halved {
                let bladeMask = RectangleMask(a: CGPoint(x: 0, y: 0),
                                              b: CGPoint(x: 0.5, y: 1))
                let haftMask = RectangleMask(a: CGPoint(x: 0, y: 0.5),
                                             b: CGPoint(x: 1, y: 1))
                return WeaponTransform(masks: [.blade: bladeMask,
                                               .haft: haftMask,
                                               .pommel: haftMask])
            }
        case .spear:
            if definition.property == .broken {
                let triangleMask = TriangleMask(a: CGPoint(x: 0, y: 0),
                                                b: CGPoint(x: 0.25, y: 1),
                                                c: CGPoint(x: 1, y: 0))
                return WeaponTransform(masks: [.blade: triangleMask])
            }
            if definition.property == .halved {
                let rectangleMask = RectangleMask(a: CGPoint(x: 0, y: 0.5),
                                                  b: CGPoint(x: 1, y: 1))
                return WeaponTransform(masks: [.blade: rectangleMask,
                                               .crossguard: rectangleMask,
                                               .haft: rectangleMask,
                                               .pommel: rectangleMask])
            }
        case .club:
            if definition.property == .broken {
                let triangleMask = TriangleMask(a: CGPoint(x: 0, y: 0),
                                                b: CGPoint(x: 0, y: 1),
                                                c: CGPoint(x: 0.75, y: 0))
                return WeaponTransform(masks: [.haft: triangleMask])
            }
            if definition.property == .halved {
                let triangleMask = TriangleMask(a: CGPoint(x: 0, y: 0),
                                                b: CGPoint(x: 0, y: 1),
                                                c: CGPoint(x: 0.75, y: 0))
                return WeaponTransform(masks: [.haft: triangleMask])
            }
        default:
            break
        }
        return WeaponTransform()
    }
}
