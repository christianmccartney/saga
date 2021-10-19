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

    public override func didAddToEntity() {
        idle()
    }

    public override func willRemoveFromEntity() {
    }

    public override func update(deltaTime seconds: TimeInterval) {
    }

    func idleAction() -> SKAction {
        if let frames = _entity.idleFrames[_entity.direction] {
            return SKAction.animate(with: frames,
                                    timePerFrame: 0.5,
                                    resize: false,
                                    restore: true)
        } else {
            return SKAction()
        }
    }

    func idleAction(_ direction: EntityDirection = .down) -> SKAction {
        if let frames = _entity.idleFrames[_entity.direction] {
            return SKAction.animate(with: frames,
                                    timePerFrame: 0.5,
                                    resize: false,
                                    restore: true)
        } else {
            return SKAction()
        }
    }

    func idle() {
        _entity.spriteNode.run(SKAction.repeatForever(idleAction()), withKey: "idle")
    }

    func idle(_ direction: EntityDirection = .down) {
        _entity.spriteNode.run(SKAction.repeatForever(idleAction(direction)), withKey: "idle")
    }
}
