//
//  MapSet.swift
//  Saga
//
//  Created by Christian McCartney on 5/23/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit
import GameplayKit

/// A `MapSet` is a group of maps described by an .sks file.
public class MapSet {
    weak var gameState: GameState?
    var sceneName: String
    var sourceScene: SKScene

    var maps: [Map]
    var initialMap: Map?
    var currentMap: Map?
    
    var roomGenerator: MapGenerator
    
    init(gameState: GameState, sceneName: String, tileSet: SKTileSet, roomGenerator: MapGenerator) {
        self.gameState = gameState
        self.sceneName = sceneName
        self.sourceScene = SKScene(size: CGSize(width: roomGenerator.width,
                                                height: roomGenerator.height))
        
        self.maps = []
        self.roomGenerator = roomGenerator
        let map = Map(tileSet: tileSet,
                      columns: roomGenerator.width,
                      rows: roomGenerator.height,
                      room: roomGenerator.generate())
        maps.append(map)
        self.initialMap = maps.first
        self.currentMap = maps.first
        map.mapSet = self
    }

    func removeChild(_ entity: Entity) {
//        gameState?.removeChild(entity)
    }

//    public init(sceneName: String, mapCount: Int) {
//        self.sceneName = sceneName
//        self.sourceScene = SKScene(fileNamed: "TileMap")!
//
//        var maps: [Map] = []
//        for index in 0...mapCount {
//            guard let mapNode = sourceScene.childNode(withName: "map_" + String(index)) as? SKTileMapNode else {
//                fatalError("Could not find map at index " + String(index))
//            }
//
//            let map = Map(mapNode: mapNode)
//            maps.append(map)
//        }
//
//        self.maps = maps
//
//        guard let initialMap = maps.first else { fatalError("Map set initialized without a Map") }
//        self.initialMap = initialMap
//        self.currentMap = initialMap
//    }

//    func swap(from oldMap: Map, to newMap: Map, in scene: SKScene) {
//        scene.removeChildren(in: [oldMap.mapNode])
//        newMap.mapNode.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
//        newMap.mapNode.setScale(2.0)
//        scene.removeChildren(in: [newMap.mapNode])
//        scene.addChild(newMap.mapNode)
//    }

//    func startIdleAnimations() {
//        currentMap?.startIdleAnimations()
//    }

    func updatePositions() {
        currentMap?.updatePositions()
    }
}

extension MapSet {
    //static let defaultMapSet = MapSet(sceneName: "scene1", mapCount: 0)
    //static let defaultMapSet = MapSet(sceneName: "scene1", tileSetNames: ["AdjacencyTileSet"])
}



