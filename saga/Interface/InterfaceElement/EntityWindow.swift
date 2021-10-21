//
//  EntityWindow.swift
//  saga
//
//  Created by Christian McCartney on 10/20/21.
//

import Foundation
import SpriteKit
import Combine

class EntityWindow: InterfaceElement {
    private var textTileMap: TextTileMap
    private var cancellables = Set<AnyCancellable>()
    private var selectedEntity: Entity?

    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        self.textTileMap = TextTileMap(fontType: .dark, columns: 10, rows: 1)
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
                let entity = highlightedEntity?.copy()
                entity?.isUserInteractionEnabled = false
                entity?.spriteNode.position = CGPoint(x: self.frame.width/4, y: self.frame.height/4)
                entity?.scale = 4
                self.selectEntity(entity)
            }.store(in: &cancellables)
        addChild(textTileMap)
    }

    private func selectEntity(_ entity: Entity?) {
        if let selectedEntity = selectedEntity {
            self.selectedEntity = nil
            removeChildren(in: [selectedEntity.spriteNode])
            interfaceDelegate?.untrack(selectedEntity)
        }
        if let entity = entity {
            selectedEntity = entity
            addChild(entity.spriteNode)
            interfaceDelegate?.track(entity)
        }
    }

    override func setupButtons() {
        
    }

    override func setPosition() {
        posByScreen(x: 0.0, y: 0.0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Entity {
//    func copyForEntityWindow() -> Entity {
//    }
}
