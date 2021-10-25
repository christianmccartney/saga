//
//  BottomBar.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class BottomBar: InterfaceElement {
    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        anchorPoint = CGPoint(x: 0.5, y: 0.0)
        enableAutomapping = false
        fillWithEdges(tileSet.tileGroups.first!)
        
        let swordButton = Button(type: .sword, action: { [weak self] button in
            guard let self = self else { return }
            
        })
        
        self.buttons = [swordButton]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupButtons() {
        var x = 0
        for button in buttons {
            addChild(button)
            let center1 = (centerOfTile(atColumn: x, row: 0) + centerOfTile(atColumn: x, row: 1)) / 2
            let center2 = (centerOfTile(atColumn: x + 1, row: 0) + centerOfTile(atColumn: x + 1, row: 1)) / 2
            button.position = (center1 + center2) / 2
            button.setScale(1.5)
            x += 2
        }
    }

    override func setPosition() {
        posByScreen(x: 0.5, y: 0.01)
    }
}
