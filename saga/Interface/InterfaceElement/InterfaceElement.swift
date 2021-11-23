//
//  InterfaceElement.swift
//  saga
//
//  Created by Christian McCartney on 10/16/21.
//

import SpriteKit

protocol InterfaceDelegate: AnyObject {
    func addChild(_ entity: Entity)
    func removeChild(_ entity: Entity)
    func track(_ entity: Entity)
    func untrack(_ entity: Entity)
    func unpresentModal()
    func presentModal(_ ofType: InterfaceElement.Type)
}

open class InterfaceElement: SKTileMapNode {
    weak var coreScene: CoreScene!
    weak var interfaceDelegate: InterfaceDelegate?
    var buttons = [Button]()
    var elements = [InterfaceElement]()

    override public init(tileSet: SKTileSet, columns: Int, rows: Int, tileSize: CGSize) {
        super.init(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons() {}
    func setPosition() {}
    func update() {
        for element in elements {
            element.update()
        }
    }

    func attachElements(_ scene: CoreScene) {
        for element in elements {
            addChild(element)
            element.coreScene = scene
            element.setPosition()
            element.setupButtons()
            element.attachElements(scene)
        }
    }
}
