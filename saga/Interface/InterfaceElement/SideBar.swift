//
//  SideBar.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class SideBar: InterfaceElement {
    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        anchorPoint = CGPoint(x: 1.0, y: 0.5)
        enableAutomapping = false
        fillWithEdges(tileSet.tileGroups.first!)
    
        let bagButton = Button(type: .bag, action: { [weak self] button in
            guard let self = self else { return }
            self.select(button)
        })
        let armorButton = Button(type: .armor, action: { [weak self] button in
            guard let self = self else { return }
            self.interfaceDelegate?.presentModal(EquipmentInspector.self)
        })
        //let nextTurnButton = Button(type: .arrows, action: { print("next turn") })
        let moveButton = Button(type: .arrow_right, action: { [weak self] button in
            guard let self = self else { return }
            self.select(button)
            Task {
                await self.coreScene?.advanceTurn()
            }
        })
        let defendButton = Button(type: .shield, action: { [weak self] button in
            guard let self = self else { return }
            self.select(button)
        })
        
        self.buttons = [bagButton, armorButton, moveButton, defendButton]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func select(_ button: Button) {
        
    }
    
    override func setupButtons() {
        var x = 0
        for button in buttons {
            addChild(button)
            let center1 = (centerOfTile(atColumn: 0, row: x) + centerOfTile(atColumn: 0, row: x)) / 2
            let center2 = (centerOfTile(atColumn: 1, row: x + 1) + centerOfTile(atColumn: 1, row: x + 1)) / 2
            button.position = (center1 + center2) / 2
            button.setScale(1.5)
            x += 2
        }
    }

    override func setPosition() {
        posByScreen(x: 0.99, y: 0.5)
    }
}

