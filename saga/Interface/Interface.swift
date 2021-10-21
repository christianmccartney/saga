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
    var selectedAction: EntityAction? = nil

    public init() {
        let stoneInterface = TileSet(InterfaceTileGroupDefinition(name: "stone_a", interfaceType: .stone_a))
        let scrollInterface = TileSet(InterfaceTileGroupDefinition(name: "scroll_a", interfaceType: .scroll_a))
        let windowInterface = TileSet(InterfaceTileGroupDefinition(name: "window", interfaceType: .window))
        
        let bottomBar = BottomBar(tileSet: stoneInterface, columns: 18, rows: 3)
        let sideBar = SideBar(tileSet: stoneInterface, columns: 3, rows: 18)
        let entityInspector = EntityInspector(tileSet: scrollInterface, columns: 8, rows: 8)
        let entityWindow = EntityWindow(tileSet: windowInterface, columns: 6, rows: 6)
        self.elements = [bottomBar, sideBar, entityInspector, entityWindow]

        for element in elements {
            element.interfaceDelegate = self
        }
    }

    func attachToCamera(_ camera: SKCameraNode, _ scene: CoreScene) {
        for element in elements {
            camera.addChild(element)
            element.zPosition = 9
            element.setPosition()
            element.setupButtons()
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

    func selectActionType(_ entityAction: EntityAction) {
        coreScene?.selectedActionType = entityAction
    }
}
