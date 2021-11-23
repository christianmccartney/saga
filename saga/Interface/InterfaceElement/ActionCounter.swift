//
//  ActionCounter.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class ActionCounter: InterfaceElement {
    let columns = 5
    let rows = 5

    var actionIndicators = [SKSpriteNode]()
    var textures = [SKTexture]()

    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)

        let texture1 = SKTexture(imageNamed: "crystal_empty")
        let texture2 = SKTexture(imageNamed: "crystal_full")
        texture1.filteringMode = .nearest
        texture2.filteringMode = .nearest

        self.textures = [texture1, texture2]
         
        self.actionIndicators = [SKSpriteNode(texture: texture1),
                                 SKSpriteNode(texture: texture1),
                                 SKSpriteNode(texture: texture1)]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupButtons() {
        var x = 0
        for indicator in actionIndicators {
            addChild(indicator)
            let position = CGPoint.avg(centerOfTile(atColumn: x, row: 0),
                                       centerOfTile(atColumn: x + 1, row: 1))
            indicator.position = position
            x += 2
        }
    }
    
    override func setPosition() {
    }
}
