//
//  CoreScene.swift
//  Saga
//
//  Created by Christian McCartney on 5/18/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
  static let none       : UInt32 = 0
  static let all        : UInt32 = UInt32.max
  static let player     : UInt32 = 0b1          // 1
  static let friendly   : UInt32 = 0b10         // 2
  static let neutral    : UInt32 = 0b100        // 4
  static let enemy      : UInt32 = 0b1000       // 8
}

public extension SKNode {
    func posByScreen(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(
            x: CGFloat((screenSizeRect.width * x) + screenSizeRect.origin.x),
            y: CGFloat((screenSizeRect.height * y) + screenSizeRect.origin.y))
    }
}

final class CoreScene: GameState {
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        IdleSystem.shared.coreScene = self
        // Map
        let caveGenerator = CAGenerator(width: 64, height: 64)
        let defaultMapGenerator = MapGenerator(width: 32, height: 32)
        let cryptGenerator = BSPGenerator(width: 80, height: 80, divisions: 5)
        let dungeonGenerator = RandomRoomGenerator(width: 64, height: 64, maxRooms: 32)

        let mapGenerator: MapGenerator
        mapGenerator = defaultMapGenerator
        
        let stoneTileDefinition = TileGroupDefinition(
            name: "stoneCobble",
            verticalWallType: .stone,
            horizontalWallType: .stone,
            floorType: .cobble2)
        let mapSet = MapSet(
            sceneName: "scene1",
            tileSet: TileSet(stoneTileDefinition),
            roomGenerator: mapGenerator)
        
        self.mapSet = mapSet
        addMapSet(mapSet)

        // Camera
        cameraNode = SKCameraNode()
        self.addChild(cameraNode)
        cameraNode.setScale(0.5)
        self.camera = cameraNode

        interface.attachToCamera(cameraNode, self)
        interface.setScale(2)

        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)

        addChildren([fighterEntity, jellyEntity, archerEntity, catEntity, druidEntity])
        
        let bedObject = StaticObject(type: .bed, position: Position(10, 15), entityDelegate: self)
        let candleObject = DynamicObject(type: .candle_a, position: Position(9, 14), entityDelegate: self)
        addChildren([bedObject, candleObject])
        
        updatePositions()
        focusOnActive()
        pause(false)
        super.didMove(to: view)
        beginCombat()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        IdleSystem.shared.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
}



extension DefaultStringInterpolation {
    mutating func appendInterpolation<T>(_ optional: T?) {
        appendInterpolation(String(describing: optional))
    }
}
