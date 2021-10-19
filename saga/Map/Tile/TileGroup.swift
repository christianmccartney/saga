//
//  TileGroup.swift
//  saga
//
//  Created by Christian McCartney on 10/15/21.
//

import SpriteKit

struct TileGroupDefinition {
    let name: String
    let verticalWallType: TileVerticalWallType
    let horizontalWallType: TileHorizontalWallType
    let floorType: TileFloorType
}

//class TileGroup: SKTileGroup {
//    public init(interfaceTileGroupDefinition: InterfaceTileGroupDefinition) {
//        let timeStarted = DispatchTime.now()
//        
//        var textureRules = [SKTileGroupRule]()
//        for textureRule in interfaceTileGroupDefinition.interfaceType.textureRules {
//            let texture = SKTexture(imageNamed: textureRule.0)
//            let textureDefinition = SKTileDefinition(texture: texture)
//            textureRules.append(SKTileGroupRule(
//                adjacency: textureRule.1,
//                tileDefinitions: [textureDefinition]))
//        }
//        super.init(rules: textureRules)
//        self.name = interfaceTileGroupDefinition.name
//    
//        let timeFinished = DispatchTime.now()
//        let time = timeFinished.uptimeNanoseconds - timeStarted.uptimeNanoseconds
//        print("TileSet \(interfaceTileGroupDefinition.name) init: \(Double(time)/1000000)")
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}



//        var verticalTextures = [SKTileDefinition]()
//        for textureWeight in tileGroupDefinition.verticalWallType.textureNames() {
//            let texture = SKTexture(imageNamed: textureWeight.0)
//            let textureDefinition = SKTileDefinition(texture: texture)
//            textureDefinition.placementWeight = textureWeight.1
//            verticalTextures.append(textureDefinition)
//        }
//
//        let upperLeftEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyUpperLeftEdge,
//            tileDefinitions: verticalTextures)
//        let leftEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyLeftEdge,
//            tileDefinitions: verticalTextures)
//        let upperRightEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyUpperRightEdge,
//            tileDefinitions: verticalTextures)
//        let rightEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyRightEdge,
//            tileDefinitions: verticalTextures)
//        let upperLeftCornerRule = SKTileGroupRule(
//            adjacency: .adjacencyUpperLeftCorner,
//            tileDefinitions: verticalTextures)
//        let upperRightCornerRule = SKTileGroupRule(
//            adjacency: .adjacencyUpperRightCorner,
//            tileDefinitions: verticalTextures)
//
//
//        var horizontalTextures = [SKTileDefinition]()
//        for textureWeight in tileGroupDefinition.horizontalWallType.textureNames() {
//            let texture = SKTexture(imageNamed: textureWeight.0)
//            let textureDefinition = SKTileDefinition(texture: texture)
//            textureDefinition.placementWeight = textureWeight.1
//            horizontalTextures.append(textureDefinition)
//        }
//
//        let upEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyUpEdge,
//            tileDefinitions: horizontalTextures)
//        let lowerLeftEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyLowerLeftEdge,
//            tileDefinitions: horizontalTextures)
//        let downEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyDownEdge,
//            tileDefinitions: horizontalTextures)
//        let lowerRightEdgeRule = SKTileGroupRule(
//            adjacency: .adjacencyLowerRightEdge,
//            tileDefinitions: horizontalTextures)
//        let lowerLeftCornerRule = SKTileGroupRule(
//            adjacency: .adjacencyLowerLeftCorner,
//            tileDefinitions: horizontalTextures)
//        let lowerRightCornerRule = SKTileGroupRule(
//            adjacency: .adjacencyLowerRightCorner,
//            tileDefinitions: horizontalTextures)
//
//
//        var centerTextures = [SKTileDefinition]()
//        for textureWeight in tileGroupDefinition.floorType.textureNames() {
//            let texture = SKTexture(imageNamed: textureWeight.0)
//            let textureDefinition = SKTileDefinition(texture: texture)
//            textureDefinition.placementWeight = textureWeight.1
//            centerTextures.append(textureDefinition)
//        }
//
//        let centerTextureRule = SKTileGroupRule(
//            adjacency: .adjacencyAll,
//            tileDefinitions: centerTextures)
//
//        super.init(rules: [centerTextureRule, upEdgeRule, lowerLeftEdgeRule, downEdgeRule,
//                          lowerRightEdgeRule, lowerLeftCornerRule, lowerRightCornerRule,
//                          upperLeftEdgeRule, leftEdgeRule, upperRightEdgeRule,
//                          rightEdgeRule, upperLeftCornerRule, upperRightCornerRule])
//        self.name = tileGroupDefinition.name
