//
//  MovableComponent.swift
//  saga
//
//  Created by Christian McCartney on 10/10/21.
//

import SpriteKit
import GameplayKit

public class MovableComponent: Component {
    public override func didAddToEntity() {
//        if entityPositionCorrect {
//            _entity.updatePosition()
//        }
    }

    public override func willRemoveFromEntity() {
        
    }

    public override func update(deltaTime seconds: TimeInterval) {
//        if entityPositionCorrect {
//            _entity.updatePosition()
//        }
    }

    var entityPositionCorrect: Bool {
        let mapPosition = _entity.mapPosition
        return mapPosition == _entity.spriteNode.position
    }
}
