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
        enableAutomapping = false
        fillWithEdges(tileSet.tileGroups.first!)
    
        let bagButton = Button(type: .bag, action: { print("bag") })
        let armorButton = Button(type: .armor, action: { print("armor") })
        //let nextTurnButton = Button(type: .arrows, action: { print("next turn") })
        let moveButton = Button(type: .arrow_right, action: { print("next turn") })
        let defendButton = Button(type: .shield, action: { print("defend") })
        let swordButton = Button(type: .sword, action: { print("sword") })
        
        self.buttons = [bagButton, armorButton, moveButton, defendButton, swordButton]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        posByScreen(x: 0.925, y: 0.5)
    }

    override func handleSelection(_ event: UIEvent) -> ButtonAction? {
//        let selectedNode = node.atPoint(event.location(in: node))
//
//        guard let button = findButton(selectedNode) else { return nil }
//        //print(String(describing: button.node.name))
//        return button.action
        return nil
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

