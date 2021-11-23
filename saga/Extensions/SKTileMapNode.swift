//
//  SKTileMapNode.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

import SpriteKit

extension SKTileMapNode {
    func fillSquare(_ tileGroup: SKTileGroup) {
        for column in 0..<numberOfColumns {
            for row in 0..<numberOfRows {
                let gridPosition = interfaceGridPosition(for: Position(column, row))
                if let tileDefinition = tileGroup.interfaceTileDefinition(for: gridPosition) {
                    setTileGroup(tileGroup,
                                 andTileDefinition: tileDefinition,
                                 forColumn: column,
                                 row: row)
                }
            }
        }
    }

    func fillCircle(_ tileGroup: SKTileGroup) {
        var fillMap: RoomMap = Array(repeating: Array(repeating: false, count: numberOfColumns + 2),
                                     count: numberOfRows + 2)
        let halfC = numberOfColumns/2
        let halfR = numberOfRows/2
        
        for column in 1..<numberOfColumns+1 {
            for row in 1..<numberOfRows+1 {
                fillMap[row][column] = Position(halfC, halfR).distance(Position(column-1, row-1)) <= halfC
            }
        }
        for col in 1..<numberOfColumns+1 {
            for row in 1..<numberOfRows+1 {
                let c = col - 1
                let r = row - 1
                var tileDefinition: SKTileDefinition?
                let n = fillMap[row+1][col]
                let s = fillMap[row-1][col]
                let e = fillMap[row][col+1]
                let w = fillMap[row][col-1]
                
                let ne = fillMap[row+1][col+1]
                let nw = fillMap[row+1][col-1]
                let se = fillMap[row-1][col+1]
                let sw = fillMap[row-1][col-1]
                
                let neighbors = [n, s, e, w].compactMap { $0 ? true : nil }.count
                let diagonals = [ne, nw, se, sw].compactMap { $0 ? true : nil }.count
                
                if fillMap[row][col] {
                    if diagonals == 3, neighbors == 4 {
                        if !ne {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 14)
                        }
                        if !nw {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 17)
                        }
                        if !se {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 15)
                        }
                        if !sw {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 16)
                        }
                    } else if neighbors > 2, diagonals > 2 {
                        let gridPosition = interfaceGridPosition(for: Position(c, r))
                        tileDefinition = tileGroup.interfaceTileDefinition(for: gridPosition)
                    } else if neighbors == 2 {
                            if n, e {
                                tileDefinition = tileGroup.interfaceTileDefinition(for: 6)
                            }
                            if n, w {
                                tileDefinition = tileGroup.interfaceTileDefinition(for: 8)
                            }
                            if s, e {
                                tileDefinition = tileGroup.interfaceTileDefinition(for: 0)
                            }
                            if s, w {
                                tileDefinition = tileGroup.interfaceTileDefinition(for: 2)
                            }
                    } else if neighbors == 1 {
                        if n {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 10) // 2
                        }
                        if w {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 13) // 0
                        }
                        if e {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 11) // 7
                        }
                        if s {
                            tileDefinition = tileGroup.interfaceTileDefinition(for: 12) // 8
                        }
                    } else if neighbors == 0 {
                        tileDefinition = tileGroup.interfaceTileDefinition(for: 9)
                    } else if neighbors > 0 {
                        let gridPosition = interfaceGridPosition(for: Position(c, r))
                        tileDefinition = tileGroup.interfaceTileDefinition(for: gridPosition)
                    }
                }
                
                if let tileDefinition = tileDefinition {
                    setTileGroup(tileGroup,
                                 andTileDefinition: tileDefinition,
                                 forColumn: c,
                                 row: r)
                }
            }
        }
    }

    func visualize(_ room: RoomMap) {
        var rowCount = 0
        for x in room.reversed() {
            print("[ ", terminator: "")
            for y in x {
                print("\(y ? 1 : 0) ", terminator: "")
            }
            print(" ] \(rowCount)")
            rowCount += 1
        }
    }
}

// 6 7 8
// 3 4 5
// 0 1 2

extension SKTileMapNode {
    func interfaceGridPosition(for tileLocation: Position) -> Int {
        if tileLocation.column == 0 {
            if tileLocation.row == 0 {
                return 6
            }
            if tileLocation.row == numberOfRows-1 {
                return 0
            }
            return 3
        }
        if tileLocation.column == numberOfColumns-1 {
            if tileLocation.row == 0 {
                return 8
            }
            if tileLocation.row == numberOfRows-1 {
                return 2
            }
            return 5
        }
        if tileLocation.row == 0 {
            return 7
        }
        if tileLocation.row == numberOfRows-1 {
            return 1
        }
        return 4
    }
}
