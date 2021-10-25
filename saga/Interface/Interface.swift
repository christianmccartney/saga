//
//  Interface.swift
//  Saga
//
//  Created by Christian McCartney on 5/28/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class Interface {
    weak var coreScene: CoreScene?
    var elements = [InterfaceElement]()

    public init() {
        let stoneInterface = TileSet(InterfaceTileGroupDefinition(name: "stone_a", interfaceType: .stone_a))
        let scrollInterface = TileSet(InterfaceTileGroupDefinition(name: "scroll_a", interfaceType: .scroll_a))
        let windowInterface = TileSet(InterfaceTileGroupDefinition(name: "window", interfaceType: .window))
        
        let bottomBar = BottomBar(tileSet: stoneInterface, columns: 15, rows: 2)
        let healthBar = HealthBar(tileSet: windowInterface, columns: 6, rows: 1)
        let manaBar = ManaBar(tileSet: windowInterface, columns: 6, rows: 1)
        let resourceBars: [InterfaceElement] = [healthBar, manaBar]
        bottomBar.elements = resourceBars
        
        let sideBar = SideBar(tileSet: stoneInterface, columns: 2, rows: 12)
        let entityInspector = EntityInspector(tileSet: scrollInterface, columns: 7, rows: 7)
        let entityWindow = EntityWindow(tileSet: windowInterface, columns: 5, rows: 5)
        self.elements = [bottomBar, sideBar, entityInspector, entityWindow]

        for element in elements {
            element.interfaceDelegate = self
        }
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func attachToCamera(_ camera: SKCameraNode, _ scene: CoreScene) {
        for element in elements {
            camera.addChild(element)
            element.zPosition = 8
            element.setPosition()
            element.setupButtons()
            element.coreScene = scene
            element.attachElements(scene)
        }
        self.coreScene = scene
    }

    func setScale(_ scale: CGFloat) {
        for element in elements {
            element.setScale(scale)
        }
    }
}

extension Interface: InterfaceDelegate {
    func addChild(_ entity: Entity) {
        coreScene?.addChild(entity)
    }
    
    func removeChild(_ entity: Entity) {
        coreScene?.removeChild(entity)
    }
    
    func track(_ entity: Entity) {
        coreScene?.track(entity)
    }
    
    func untrack(_ entity: Entity) {
        System.shared.removeEntity(entity)
        coreScene?.untrack(entity)
    }
}
