//
//  EntityDamage.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SpriteKit

extension Entity {
    private func generatePhysicsBody(for node: SKNode) {
        let body = SKPhysicsBody(rectangleOf: node.frame.size)
        body.isDynamic = true
        body.affectedByGravity = true
        body.allowsRotation = true
        body.friction = 0.0
        body.collisionBitMask = PhysicsCategory.ui
        body.contactTestBitMask = PhysicsCategory.ui
        body.categoryBitMask = PhysicsCategory.ui
        body.mass = 0.05
        node.physicsBody = body
    }

    private func applyRandomForceScaled(to node: SKNode, scale: CGFloat) {
        guard let body = node.physicsBody else { return }
        var clamp = min(scale, 1000.0)
        clamp = max(scale, 1.0)
        let unitScale = clamp.map(from: 1.0...1000.1, to: 0.0...1.0)
        let easingScale: CGFloat = Easing.easeOut.curve(.quintic)(unitScale)
        body.applyImpulse(CGVector(dx: 4 * (0.25 + easingScale), dy: 4))
    }

    private func applyConstantForce(to node: SKNode) {
        guard let body = node.physicsBody else { return }
        body.applyImpulse(CGVector(dx: 0, dy: 6.0))
    }
    
    func applyDamage(damage: Float, position: CGPoint) {
        guard let map = map else { return }
        let truncatedDamage = floor(damage * 10) / 10
        let text = "-" + String(truncatedDamage)
        let textTileMap = TextTileMap(fontType: .light, columns: text.count + 1, rows: 1)
        generatePhysicsBody(for: textTileMap)
        textTileMap.color = .red
        textTileMap.colorBlendFactor = 1.0
        textTileMap.applyString(text, startingAt: Position(0, 0))
        textTileMap.position = position
        map.addChild(textTileMap)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        applyRandomForceScaled(to: textTileMap, scale: CGFloat(damage))
        textTileMap.run(sequence) {
            map.removeChildren(in: [textTileMap])
        }
    }
    
    func applyHeal(heal: Float, position: CGPoint)  {
        guard let map = map else { return }
        let truncatedDamage = floor(heal * 10) / 10
        let text = "+" + String(truncatedDamage)
        let textTileMap = TextTileMap(fontType: .light, columns: text.count + 1, rows: 1)
        generatePhysicsBody(for: textTileMap)
        textTileMap.color = .green
        textTileMap.colorBlendFactor = 1.0
        textTileMap.applyString(text, startingAt: Position(0, 0))
        textTileMap.position = position
        map.addChild(textTileMap)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        applyConstantForce(to: textTileMap)
        textTileMap.run(sequence) {
            map.removeChildren(in: [textTileMap])
        }
    }
}
