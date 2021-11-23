//
//  TextTileMap.swift
//  saga
//
//  Created by Christian McCartney on 10/17/21.
//

import SpriteKit

class TextTileMap: SKTileMapNode {
    let fontType: FontType

    fileprivate var tileGroup: TextTileGroup {
        return tileSet.tileGroups[FontType.allCases.firstIndex(of: fontType) ?? 0] as! TextTileGroup
    }
    
    public init(fontType: FontType, columns: Int, rows: Int) {
        self.fontType = fontType
        super.init(
            tileSet: TextTileSet.shared,
            columns: columns,
            rows: rows,
            tileSize: TEXT_SPRITE_SIZE)
        anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tileDefinition(_ character: Character) -> SKTileDefinition {
        return tileGroup.characterToTileDefinition(character)
    }

    func applyString(_ string: String, startingAt position: Position) {
        var column = position.column
        var row = position.row
        for character in string {
            if character == " " {
                column += 1
                continue
            }
            if column >= self.numberOfColumns {
                row -= 1
                column = position.column
            }
            if character == "\n" {
                row -= 1
                column = position.column
                continue
            }
            if row > self.numberOfRows {
                break
            }
            setTileGroup(
                tileGroup,
                andTileDefinition: tileDefinition(character),
                forColumn: column,
                row: row)
            column += 1
        }
    }

    func clearText() {
        fill(with: nil)
    }
}
