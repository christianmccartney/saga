//
//  EquipmentInspector.swift
//  saga
//
//  Created by Christian McCartney on 10/29/21.
//

import SpriteKit

class EquipmentInspector: InterfaceElement {
    var closeButton = Button(type: .close_stone, action: { _ in })
    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        enableAutomapping = false
        fillSquare(tileSet.tileGroups.first!)
        anchorPoint = CGPoint(x: 0.5, y: 0.4)
        
        self.closeButton = Button(type: .close_stone, action: { [weak self] _ in
            guard let self = self else { return }
            self.interfaceDelegate?.presentModal(EquipmentInspector.self)
        })
        self.addChild(closeButton)
        
        self.buttons = []
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setupButtons() {
        closeButton.position = centerOfTile(atColumn: numberOfColumns - 1, row: numberOfRows - 1)
        
    }
}
