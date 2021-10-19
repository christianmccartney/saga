//
//  TileSet.swift
//  saga
//
//  Created by Christian McCartney on 10/14/21.
//

import SpriteKit

class TileSet: SKTileSet {
    public init(_ tileGroupDefinition: TileGroupDefinition) {
        let timeStarted = DispatchTime.now()
    
        var verticalTextures = [SKTileDefinition]()
        for (texture, weight) in tileGroupDefinition.verticalWallType.textureNames() {
            let texture = SKTexture(imageNamed: texture)
            let textureDefinition = SKTileDefinition(texture: texture)
            textureDefinition.placementWeight = weight
            verticalTextures.append(textureDefinition)
        }
        let verticalTileRule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: verticalTextures)
        let verticalTileGroup = SKTileGroup(rules: [verticalTileRule])
        
        var horizontalTextures = [SKTileDefinition]()
        for (texture, weight) in tileGroupDefinition.horizontalWallType.textureNames() {
            let texture = SKTexture(imageNamed: texture)
            let textureDefinition = SKTileDefinition(texture: texture)
            textureDefinition.placementWeight = weight
            horizontalTextures.append(textureDefinition)
        }
        let horizontalTileRule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: horizontalTextures)
        let horizontalTileGroup = SKTileGroup(rules: [horizontalTileRule])
        
        var centerTextures = [SKTileDefinition]()
        for (texture, weight) in tileGroupDefinition.floorType.textureNames() {
            let texture = SKTexture(imageNamed: texture)
            let textureDefinition = SKTileDefinition(texture: texture)
            textureDefinition.placementWeight = weight
            centerTextures.append(textureDefinition)
        }
        let centerTileRule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: centerTextures)
        let centerTileGroup = SKTileGroup(rules: [centerTileRule])
        super.init(tileGroups: [centerTileGroup, horizontalTileGroup, verticalTileGroup])

        let timeFinished = DispatchTime.now()
        let time = timeFinished.uptimeNanoseconds - timeStarted.uptimeNanoseconds
        print("TileSet \(tileGroupDefinition.name) init: \(Double(time)/1000000)")
    }

    public init(_ interfaceTileGroupDefinition: InterfaceTileGroupDefinition) {
        let timeStarted = DispatchTime.now()
    
        var textureDefinitions = [SKTileDefinition]()
        for texture in interfaceTileGroupDefinition.interfaceType.textures {
            let texture = SKTexture(imageNamed: texture)
            let textureDefinition = SKTileDefinition(texture: texture)
            textureDefinitions.append(textureDefinition)
        }
        let rule = SKTileGroupRule(adjacency: .adjacencyAll, tileDefinitions: textureDefinitions)
        let tileGroup = SKTileGroup(rules: [rule])
        super.init(tileGroups: [tileGroup])
    
        let timeFinished = DispatchTime.now()
        let time = timeFinished.uptimeNanoseconds - timeStarted.uptimeNanoseconds
        print("TileSet \(interfaceTileGroupDefinition.name) init: \(Double(time)/1000000)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//    public init(_ interfaceTileGroupDefinitions: [InterfaceTileGroupDefinition]) {
//        let timeStarted = DispatchTime.now()
//
//        let tileGroups = interfaceTileGroupDefinitions.map { TileGroup(interfaceTileGroupDefinition: $0) }
//        super.init(tileGroups: tileGroups)
//
//        let timeFinished = DispatchTime.now()
//        let time = timeFinished.uptimeNanoseconds - timeStarted.uptimeNanoseconds
//        print("TileSet \(interfaceTileGroupDefinitions) init: \(Double(time)/1000000)")
//    }
