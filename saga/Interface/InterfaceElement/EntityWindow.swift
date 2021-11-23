//
//  EntityWindow.swift
//  saga
//
//  Created by Christian McCartney on 10/20/21.
//
 
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
        fillSquare(tileSet.tileGroups.first!)
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
    
    override func attachElements(_ scene: CoreScene) {
        scene.$highlightedEntity
            .receive(on: DispatchQueue.main)
            .sink { [weak self] highlightedEntity in
                guard let self = self else { return }
                let entity = highlightedEntity?.copyEntity()
                entity?.isUserInteractionEnabled = false
                entity?.spriteNode.position = self.centerOfTile(atColumn: self.numberOfColumns/2,
                                                                row: self.numberOfRows/2)
                entity?.scale = 4
                self.selectEntity(entity)
            }.store(in: &cancellables)
        for element in elements {
            element.attachElements(scene)
        }
    }

    override func setPosition() {
        posByScreen(x: 0.0, y: 0.0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
