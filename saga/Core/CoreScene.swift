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
    static let allCases: [UInt32] = [PhysicsCategory.none, PhysicsCategory.player, PhysicsCategory.friendly, PhysicsCategory.neutral, PhysicsCategory.enemy]
    static let none       : UInt32 = 0
    static let player     : UInt32 = 0b1          // 1
    static let friendly   : UInt32 = 0b10         // 2
    static let neutral    : UInt32 = 0b100        // 4
    static let enemy      : UInt32 = 0b1000       // 8
    static let ui         : UInt32 = 0b10000       // 16
    static let all        : UInt32 = UInt32.max
}

public extension SKNode {
    func posByScreen(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(
            x: CGFloat((CoreScene.screenSizeRect.width * x) + CoreScene.screenSizeRect.origin.x),
            y: CGFloat((CoreScene.screenSizeRect.height * y) + CoreScene.screenSizeRect.origin.y))
    }
}

final class CoreScene: GameState {
    static var screenSizeRect: CGRect = CGRect()
    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    override func didMove(to view: SKView) {
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        ActorSystem.shared.gameState = self
        Selection.shared.gameState = self
        mapController.gameState = self
        mapController.generateMap()

        // Camera
        cameraNode = Camera()
        self.addChild(cameraNode)
        cameraNode.setScale(MIN_ZOOM_SCALE)
        self.camera = cameraNode

        interface.attachToCamera(cameraNode, self)
        interface.setScale(2.25)

        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)

        addChildren([fighterEntity])//, jellyEntity, archerEntity, catEntity, druidEntity, angelEntity])
        fighterEntity.abilities = [fireball, iceball, voidball]

//        let bedObject = StaticObject(type: .bed, position: Position(10, 15), entityDelegate: self)
//        let candleObject = DynamicObject(type: .candles_a, position: Position(9, 14), entityDelegate: self)
//        addChildren([bedObject, candleObject])

        for entity in entities where entity.faction == .player {
            playerEntity = entity
            break
        }
        
        interface.update()
        updatePositions()
        focusOnActive()
        pause(false)
        super.didMove(to: view)
        if !inCombat {
            beginCombat()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let modal = interface.presentedModal, modal.contains(t.location(in: cameraNode)) {
                continue
            }
            let location = t.location(in: self)
            print("touched \(mapController.map.tileColumnIndex(fromPosition: location)), \(mapController.map.tileRowIndex(fromPosition: location))")
            let touchedNodes = nodes(at: location)
            let entity = touchedNodes.compactMap { $0.entity as? Entity }.first
            self.touchDown(location, entity: entity)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let modal = interface.presentedModal, modal.contains(t.location(in: cameraNode)) {
                continue
            }
            self.touchMoved(t.location(in: self))
        }
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
        ActorSystem.shared.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
    }
}

extension DefaultStringInterpolation {
    mutating func appendInterpolation<T>(_ optional: T?) {
        appendInterpolation(String(describing: optional))
    }
}

extension CoreScene {
    func refreshMap() {
        guard let player = entities.first(where: { $0.faction == .player }) else { return }
        mapController.removeAll()
        mapController.fill()
    }
    
// Map
//        let caveGenerator = CAGenerator(width: 64, height: 64)
//        let defaultMapGenerator = MapGenerator(width: 32, height: 32)
//        let cryptGenerator = BSPGenerator(width: 80, height: 80, divisions: 5, objectPlacer: cryptObjectPlacer)
//        let dungeonGenerator = RandomRoomGenerator(width: 64, height: 64, maxRooms: 32)
//        let dungeonGenerator = MaskMapGenerator(width: 64,
//                                                height: 64,
//                                                roomDefinitions: [LibraryRoomDefinition.smallLibraryRoomDefinition],
//                                                maxRooms: 32)
}
