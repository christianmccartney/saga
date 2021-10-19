//
//  Interface.swift
//  Saga
//
//  Created by Christian McCartney on 5/28/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class Interface {
    var elements = [InterfaceElement]()

    public init() {
        let stoneInterface = TileSet(InterfaceTileGroupDefinition(name: "stone_a", interfaceType: .stone_a))
        let scrollInterface = TileSet(InterfaceTileGroupDefinition(name: "scroll_a", interfaceType: .scroll_a))
        
        let bottomBar = BottomBar(tileSet: stoneInterface, columns: 18, rows: 3)
        let sideBar = SideBar(tileSet: stoneInterface, columns: 3, rows: 18)
        let entityInspector = EntityInspector(tileSet: scrollInterface, columns: 8, rows: 8)
        self.elements = [bottomBar, sideBar, entityInspector]
    }

    func attachToCamera(_ camera: SKCameraNode, _ scene: SKScene) {
        for element in elements {
            camera.addChild(element)
            element.zPosition = 9
            element.setPosition()
            element.setupButtons()
        }
    }

    func setScale(_ scale: CGFloat) {
        for element in elements {
            element.setScale(scale)
        }
    }

    func handleSelection(_ event: UIEvent) -> ButtonAction? {
        for element in elements {
            if let action = element.handleSelection(event) {
                return action
            }
        }
        return nil
    }
}
