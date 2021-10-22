//
//  InputManager.swift
//  Saga
//
//  Created by Christian McCartney on 8/16/21.
//  Copyright © 2021 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

open class InputManager: SKScene {
    var previousCameraPoint = CGPoint.zero
    var previousCameraScale = CGFloat.zero

    open override func didMove(to view: SKView) {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if sender.state == .began {
          previousCameraPoint = camera.position
        }
        let translation = sender.translation(in: self.view) * camera.xScale
        let newPosition = CGPoint(x: previousCameraPoint.x + translation.x * -1, y: previousCameraPoint.y + translation.y)
        camera.position = newPosition
    }

    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
    
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        let newScale = previousCameraScale * 1 / sender.scale
        if newScale <= 2, newScale >= 0.5 {
            camera.setScale(newScale)
        }
    }
}
