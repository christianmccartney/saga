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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupButtons() {}

    override func setPosition() {
        posByScreen(x: 0.5, y: 0.0)
    }
}
