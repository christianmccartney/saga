//
//  IceballAnimations.swift
//  saga
//
//  Created by Christian McCartney on 11/19/21.
//

import SpriteKit

//private let red =
//private let green =
//private let blue =

extension UIColor {
    // rainbow UIColor(red: 82, green: 161, blue: 236, alpha: 1.0)
    static let lightBlue = UIColor(red: 82 / 255, green: 161 / 255, blue: 236 / 255, alpha: 1.0)
}

let iceballAttackAnimation: AbilityAnimation = { caster, target, position, closure in
    let mapController = MapController.shared
    let casterPosition = caster.mapPosition
    let point: CGPoint
    if let target = target {
        point = mapController.centerOfTile(target.position.column, target.position.row)
    } else {
        point = mapController.centerOfTile(position.column, position.row)
    }
    guard let iceballTexture = EffectType.textures[EffectType.iceball],
          let explosionTextures = AnimatedEffect.textures[.iceImpact] else {
              fatalError("Failed to get Fireball resources")
          }
    
    func generateIceball(count: Int, depth: Int, closure: @escaping () -> ()) {
        let particleEmitter = SKEmitterNode()
        EmitterType.fire(.lightBlue).setting(for: particleEmitter)
        particleEmitter.targetNode = mapController.map
        particleEmitter.particleScale = 0.025
        
        iceballTexture.filteringMode = .nearest
        let iceballNode = Node(texture: iceballTexture)
        iceballNode.setScale(0.5)
        iceballNode.addChild(particleEmitter)
        
        let tileAbove = mapController.centerOfTile(caster.position.column, caster.position.row + 1)
        let middlePosition = (casterPosition + tileAbove) / 2
        iceballNode.position = (casterPosition + middlePosition) / 2
        mapController.addChild(iceballNode)
        
        let path = UIBezierPath()
        path.move(to: casterPosition)
        let midPoint = (point + casterPosition) / 2
        let controlPoint = CGPoint(x: midPoint.x + CGFloat.random(in: -64...64),
                                   y: midPoint.y + CGFloat.random(in: -64...64))
        let endPoint = CGPoint(x: point.x + CGFloat.random(in: -5...5),
                               y: point.y + CGFloat.random(in: -5...5))
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        // Animate effect
        let direction = CGVector(dx: point.x - casterPosition.x, dy: point.y - casterPosition.y)
        let animate = SKAction.follow(path.cgPath, asOffset: false, orientToPath: true, speed: 100)
        animate.timingFunction = Easing.easeIn.curve(.cubic)
        iceballNode.run(animate) {
            mapController.removeChildren(in: [iceballNode])
            // Explosion effect
            let explosionNode = Node(texture: explosionTextures.first!)
            explosionNode.setScale(0.5)
            let explosionAnimation = SKAction.animate(with: explosionTextures, timePerFrame: 0.1)
            explosionNode.position = endPoint
            mapController.addChild(explosionNode)
            explosionNode.run(explosionAnimation) {
                mapController.removeChildren(in: [explosionNode])
                if !(count < depth) {
                    closure()
                }
            }
        }
        if count < depth {
            generateIceball(count: count+1, depth: depth, closure: closure)
        }
    }
    generateIceball(count: 0, depth: 2, closure: closure)
}

let iceballDeathAnimation: DeathAnimation = { entity in
    let mapController = MapController.shared
    let entityPosition = entity.mapPosition

    guard let iceSpark = AnimatedEffect.textures[.iceSpark] else { return }
    let emitter = SKEmitterNode()
    EmitterType.bits(.lightBlue).setting(for: emitter)
    emitter.position = entityPosition
    emitter.particleSpeed = 0
    emitter.particleBirthRate = 800.0
    emitter.particleAlpha = 0.75
    emitter.particleRotationRange = CGFloat.pi * 0.5
//    emitter.numParticlesToEmit = 200
    emitter.particlePositionRange = CGVector(dx: 16, dy: 16)
//    let emitter = GravityEmitter(type: .bits(UIColor(red: red, green: green, blue: blue, alpha: 1.0)),
//                                 acceleration: 75,
//                                 position: entityPosition)
    mapController.addChild(emitter)
    let fadeDark = SKAction.colorize(with: .darkGray, colorBlendFactor: 1.0, duration: 0.25)
    entity.spriteNode.run(fadeDark)

    let sparkNode = Node(texture: iceSpark.first!)
    let spark = SKAction.animate(with: iceSpark, timePerFrame: 0.1)
    sparkNode.position = entityPosition
    mapController.addChild(sparkNode)
    sparkNode.run(spark) {
        mapController.removeChildren(in: [sparkNode])
    }

    let gleam = SKAction.colorize(with: .white,
                                  colorBlendFactor: 1.0,
                                  duration: 0.25)
    let reverseGleam = gleam.reversed()
    let gleamAction = SKAction.sequence([gleam, reverseGleam])
    emitter.particleAction = gleamAction
    
    let node = SKSpriteNode()
    let wait = SKAction.wait(forDuration: 0.5)
    mapController.addChild(node)
    
    node.run(wait) {
//        emitter.particleSpeed = 100.0
        emitter.particleBirthRate = 100.0
        emitter.particleSpeedRange = 50.0
        emitter.emissionAngleRange = 2 * CGFloat.pi
        node.run(wait) {
            mapController.removeChild(entity)
            node.run(wait) {
                mapController.removeChildren(in: [emitter])
                mapController.removeChildren(in: [node])
            }
        }
    }
}
