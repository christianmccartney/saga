//
//  IdleComponent.swift
//  saga
//
//  Created by Christian McCartney on 10/10/21.
//

import SpriteKit
import GameplayKit

public class IdleComponent: Component {
    var isIdling = false

    public override func didAddToEntity() {}

    public override func update(deltaTime seconds: TimeInterval) {}

    var idleAction: SKAction {
        if let frames = _entity.idleFrames[_entity.direction] {
            return SKAction.animate(with: frames,
                                    timePerFrame: 0.5,
                                    resize: false,
                                    restore: true)
        } else {
            return SKAction()
        }
    }

    var reversedIdleAction: SKAction {
        if let frames = _entity.idleFrames[_entity.direction] {
            return SKAction.animate(with: frames.reversed(),
                                    timePerFrame: 0.5,
                                    resize: false,
                                    restore: true)
        } else {
            return SKAction()
        }
    }

    func idle() {
        _entity.spriteNode.run(SKAction.repeatForever(idleAction), withKey: "idle")
    }

    override func copy() -> Component {
        return IdleComponent()
    }
}
