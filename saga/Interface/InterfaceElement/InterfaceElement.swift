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
}

open class InterfaceElement: SKTileMapNode {
    weak var coreScene: CoreScene?
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

    func fillWithEdges(_ tileGroup: SKTileGroup) {
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let gridPosition = interfaceGridPosition(for: Position(column, row))
                if let tileDefinition = tileGroup.interfaceTileDefinition(for: gridPosition) {
                    setTileGroup(tileGroup,
                                 andTileDefinition: tileDefinition,
                                 forColumn: column,
                                 row: row)
                }
            }
        }
    }

    func attachElements(_ scene: CoreScene) {
        for child in elements {
            addChild(child)
            child.coreScene = scene
            child.setPosition()
            child.setupButtons()
        }
    }
}
