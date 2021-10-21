//
//  SideBar.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class SideBar: InterfaceElement {
    private weak var selectedButton: Button?

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
            self.select(button)
        })
        //let nextTurnButton = Button(type: .arrows, action: { print("next turn") })
        let moveButton = Button(type: .arrow_right, action: { [weak self] button in
            guard let self = self else { return }
            self.select(button)
        })
        let defendButton = Button(type: .shield, action: { [weak self] button in
            guard let self = self else { return }
            self.select(button)
        })
        let swordButton = Button(type: .sword, action: { [weak self] button in
            guard let self = self else { return }
            self.select(button)
        })
        
        self.buttons = [bagButton, armorButton, moveButton, defendButton, swordButton]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func select(_ button: Button) {
        selectedButton?.select()
        if selectedButton == button {
            selectedButton = nil
            return
        }
        button.select()
        selectedButton = button
    }
    
    override func setupButtons() {
        var x = 2
        for button in buttons {
            addChild(button)
            button.position = centerOfTile(atColumn: numberOfColumns/2, row: x)
            button.setScale(1.75)
            x += 2
        }
    }

    override func setPosition() {
        posByScreen(x: 1.0, y: 0.5)
    }

    func findButton(_ node: SKNode) -> Button? {
        for button in buttons {
            if button == node {
                return button
            }
        }
        return nil
    }
}

