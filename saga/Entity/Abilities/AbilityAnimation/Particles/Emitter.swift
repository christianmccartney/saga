//
//  Emitter.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

import SpriteKit

enum EmitterType {
    case blood
    case sparks

    func setting(for emitter: SKEmitterNode) {
        switch self {
        case .blood:
            emitter.particleSize = CGSize(width: 10, height: 10)
            emitter.particleBirthRate = 25.0
            emitter.particleLifetime = 1.0
            emitter.particlePositionRange = CGVector(dx: 5, dy: 5)
            emitter.particleAlphaRange = 0.2
            emitter.particleScale = 0.1
            emitter.particleScaleRange = 0.05
            emitter.particleSpeed = 15.0
            emitter.particleColor = .red
            emitter.particleColorBlendFactor = 1.0
            emitter.particleColorSequence = nil
        case .sparks:
            emitter.particleTexture = SKTexture(imageNamed: "spark")
            emitter.particleSize = CGSize(width: 10, height: 10)
            emitter.particleBirthRate = 25.0
            emitter.particleLifetime = 1.0
            emitter.particlePositionRange = CGVector(dx: 5, dy: 5)
            emitter.particleAlphaRange = 0.2
            emitter.particleScale = 0.1
            emitter.particleScaleRange = 0.05
            emitter.particleSpeed = 100.0
            emitter.particleColorBlendFactor = 1.0
            emitter.particleColorSequence = nil
        }
    }
}

enum EmitterDirection: Double, CaseIterable {
    case ne = 0.78539 // pi * 1/4
    case nw = 2.35619 // pi * 3/4
    case sw = 3.92699 // pi * 5/4
    case se = 5.49778 // pi * 7/4
    
    var x: Double {
        switch self {
        case .ne:
            return -1.0
        case .nw:
            return 1.0
        case .sw:
            return 1.0
        case .se:
            return -1.0
        }
    }
    
    var y: Double {
        switch self {
        case .ne:
            return -1.0
        case .nw:
            return -1.0
        case .sw:
            return 1.0
        case .se:
            return 1.0
        }
    }
}

protocol Emitter {
    var emitters: [SKEmitterNode] { get set }
}

class GravityEmitter: Emitter {
    var emitters: [SKEmitterNode]
    var position: CGPoint {
        willSet {
            emitters.forEach { $0.position = position }
        }
    }
    
    init(type: EmitterType, acceleration: Double, position: CGPoint = CGPoint()) {
        self.emitters = []
        self.position = CGPoint()
        for direction in EmitterDirection.allCases {
            let emitter = DirectionalEmitter(type: type, acceleration: acceleration, direction: direction)
            emitter.position = position
            emitters.append(emitter)
        }
    }

//    func run(_ action: SKAction) async {
//        await withTaskGroup(of: Void.self) { taskGroup in
//            for emitter in emitters {
//                taskGroup.addTask { await emitter.run(action) }
//            }
//        }
//    }
    func run(_ action: SKAction, completion: @escaping () -> ()) {
        for emitter in emitters {
            emitter.run(action) {
                if emitter == self.emitters.last {
                    completion()
                }
            }
        }
    }
    
    func targetNode(_ skNode: SKNode) {
        for emitter in emitters {
            emitter.targetNode = skNode
        }
    }
}

class DirectionalEmitter: SKEmitterNode {
    
    init(type: EmitterType, acceleration: Double, direction: EmitterDirection) {
        super.init()
        type.setting(for: self)
        
        emissionAngle = direction.rawValue
        emissionAngleRange = 1.57079 // pi * 1/2
        xAcceleration = acceleration * direction.x
        yAcceleration = acceleration * direction.y
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
