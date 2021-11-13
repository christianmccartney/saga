//
//  ItemSlot.swift
//  saga
//
//  Created by Christian McCartney on 10/31/21.
//

import SpriteKit

enum ItemSlotType {
    case head
    case chest
    case rightArm
    case leftArm
    
    func position(in parent: SKNode) -> CGPoint {
        switch self {
        case .head:
            return CGPoint(x: parent.frame.width/4, y: parent.frame.height/4)
        case .chest:
            return CGPoint(x: parent.frame.width/4, y: parent.frame.height/2)
        case .rightArm:
            return CGPoint(x: parent.frame.width/3, y: parent.frame.height/2)
        case .leftArm:
            return CGPoint(x: parent.frame.width/5, y: parent.frame.height/2)
        }
    }
}

class ItemSlot: InterfaceElement {
    let type: ItemSlotType
    
    public init(tileSet: SKTileSet, columns: Int, rows: Int, type: ItemSlotType) {
        self.type = type
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        enableAutomapping = false
        fillWithEdges(tileSet.tileGroups.first!)
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func setupButtons() {
        guard let parent = parent else { return }
        position = type.position(in: parent)
    }
}
