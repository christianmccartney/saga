//
//  ManaBar.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SpriteKit
import Combine

class ManaBar: InterfaceElement {
    private var playerEntitySubscription: AnyCancellable?
    private var playerEntityManaSubscription: AnyCancellable?
    var maskNode: SKShapeNode?

    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        precondition(columns >= 3)
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        anchorPoint = CGPoint(x: 1.0, y: 0.0)
        enableAutomapping = false
    
        let cropNode = SKCropNode()
        let emptyTextures = ResourceBar.emptyMana.textures()
        let fullTextures = ResourceBar.fullMana.textures()
        for x in 0..<numberOfColumns {
            let index: Int
            if x == 0 {
                index = 0
            } else if x == numberOfColumns - 1 {
                index = 2
            } else {
                index = 1
            }
            let emptyNode = Node(texture: emptyTextures[index])
            let fullNode = Node(texture: fullTextures[index])
            addChild(emptyNode)
            cropNode.addChild(fullNode)
            emptyNode.position = centerOfTile(atColumn: x, row: 0)
            fullNode.position = centerOfTile(atColumn: x, row: 0)
        }
        self.maskNode = SKShapeNode(rectOf: mapSize)
        self.maskNode?.fillColor = .white
        self.maskNode?.position = CGPoint(x: -mapSize.width/2, y: mapSize.height/2)
        cropNode.maskNode = maskNode
        addChild(cropNode)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setPosition() {
        guard let parent = parent else { return }
        position = CGPoint(x: parent.frame.width/2, y: parent.frame.height)
    }

    override func setupButtons() {
        guard let coreScene = coreScene else { return }

        playerEntitySubscription = coreScene.$playerEntity
            .sink { [weak self] playerEntity in
                guard let self = self else { return }
                if let playerEntity = playerEntity {
                    self.playerEntityManaSubscription = playerEntity.statistics.$mana
                        .sink { [weak self] mana in
                            guard let self = self else { return }
                            let movePercent = 1.0 - CGFloat(mana / playerEntity.statistics.maxMana)
                            let newPos = CGPoint(x: (-self.mapSize.width/2) + (self.mapSize.width * movePercent),
                                                 y: self.mapSize.height/2)
                            let animation = SKAction.move(to: newPos, duration: 0.25)
                            self.maskNode?.run(animation)
                        }
                } else {
                    self.playerEntityManaSubscription = nil
                }
        }
    }
}
