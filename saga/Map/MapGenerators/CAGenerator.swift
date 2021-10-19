//
//  CAGenerator.swift
//  saga
//
//  Created by Christian McCartney on 10/14/21.
//

import Foundation

// Generates room using cellular automata
class CAGenerator: MapGenerator {
    let birthLimit: Int
    let deathLimit: Int
    let simulationSteps: Int
    let generationChance: Double
    
    public init(width: Int,
                height: Int,
                birthLimit: Int = 4,
                deathLimit: Int = 3,
                simulationSteps: Int = 5,
                generationChance: Double = 0.4) {
        self.birthLimit = birthLimit
        self.deathLimit = deathLimit
        self.simulationSteps = simulationSteps
        self.generationChance = generationChance
        super.init(width: width, height: height)
    }

    func initializeMap(map: inout RoomMap, generationChance: Int) {
        for x in 0..<width {
            for y in 0..<height {
                if x == 0 || y == 0 || x == width-1 || y == height-1 {
                    map[y][x] = true
                } else {
                    map[y][x] = Int.random(in: 1...100) < generationChance
                }
            }
        }
    }

    override func generate() -> RoomMap {
        func countNeighbors(map: inout RoomMap, x: Int, y: Int) -> Int {
            var count = 0
            for i in x-1...x+1 {
                for j in y-1...y+1 {
                    if i == x, j == y { continue }
                    if map[j][i] {
                        count += 1
                    }
                }
            }
            return count
        }
    
        func simulate(map: inout RoomMap, map2: inout RoomMap) {
            for x in 1..<width-1 {
                for y in 1..<height-1 {
                    let neighbors = countNeighbors(map: &map, x: x, y: y)
                    if map[y][x] {
                        if neighbors < deathLimit {
                            map2[y][x] = false
                        } else {
                            map2[y][x] = true
                        }
                    } else {
                        if neighbors > birthLimit {
                            map2[y][x] = true
                        } else {
                            map2[y][x] = false
                        }
                    }
                }
            }
        }
        
        var map1: [[Bool]] = Array(repeating: Array(repeating: false, count: width), count: height)
        initializeMap(map: &map1, generationChance: Int(generationChance*100))
        var map2 = map1
        var which = true
    
        for step in 0..<simulationSteps {
            if step%2==0 {
                simulate(map: &map1, map2: &map2)
            } else {
                simulate(map: &map2, map2: &map1)
            }
            which = !which
        }

        func invert(_ map: inout RoomMap) {
            for x in 0..<width {
                for y in 0..<height {
                    map[y][x] = !map[y][x]
                }
            }
        }
        
        if which { invert(&map1) } else { invert(&map2) }

        return which ? map1 : map2
    }
}
