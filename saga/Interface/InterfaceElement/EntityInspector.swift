//
//  EntityInspector.swift
//  saga
//
//  Created by Christian McCartney on 10/16/21.
//

import Foundation
import SpriteKit
import Combine

class EntityInspector: InterfaceElement {
    private var cancellables = Set<AnyCancellable>()
    private var textTileMap: TextTileMap
    
    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        self.textTileMap = TextTileMap(fontType: .dark, columns: 20, rows: 17)
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        enableAutomapping = false
        fillWithEdges(tileSet.tileGroups.first!)

        Selection.shared.$highlightedEntity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] highlightedEntity in
                guard let self = self else { return }
                self.updateEntity(highlightedEntity)
            }.store(in: &cancellables)
        addChild(textTileMap)
        anchorPoint = CGPoint(x: 0, y: 1.0)
        textTileMap.anchorPoint = CGPoint(x: 0, y: 1.0)
    }

    override func setupButtons() {
        
    }

    override func setPosition() {
        posByScreen(x: 0, y: 1.0)
    }

    private func updateEntity(_ entity: Entity?) {
        clearText()
        guard let entity = entity else {
            updateText("nothing selected")
            return
        }
        updateText(entity.entityDescription)
    }

    private func updateText(_ text: String) {
        textTileMap.applyString(text, startingAt: Position(1, textTileMap.numberOfRows - 2))
//        addChild(textTileMap)
    }

    private func clearText() {
        textTileMap.clearText()
//        removeChildren(in: [textTileMap])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
