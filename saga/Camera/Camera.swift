//
//  Camera.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

final class Camera {

    var cameraNode: SKCameraNode

    public init() {
        self.cameraNode = SKCameraNode()
    }

    public init(cameraNode: SKCameraNode) {
        self.cameraNode = cameraNode
    }

    func setScale(_ scale: CGFloat) {
        cameraNode.setScale(scale)
    }

    func focus(on position: CGPoint) {
        cameraNode.position = position
    }
}

