//
//  TextTileMap.swift
//  saga
//
//  Created by Christian McCartney on 10/17/21.
//

import SpriteKit

fileprivate class TextDefinition: SKTileGroupRule {
    let fontType: FontType
    init(fontType: FontType) {
        self.fontType = fontType
        var tileDefinitions = [SKTileDefinition]()
        let spriteSheet = SKTexture(imageNamed: "tiny_dungeon_font")
        for i in 0..<String.supportedCharacters.count {
            let x = CGFloat(i % TEXT_SPRITE_SHEET_WRAP) * TEXT_SPRITE_WIDTH
            let y = CGFloat((((i / TEXT_SPRITE_SHEET_WRAP) + 1) % 2) + fontType.rawValue) * TEXT_SPRITE_HEIGHT
            let texture = SKTexture(
                regularRect: CGRect(
                    x: x,
                    y: y,
                    width: TEXT_SPRITE_WIDTH,
                    height: TEXT_SPRITE_HEIGHT),
                inTexture: spriteSheet)
            tileDefinitions.append(SKTileDefinition(texture: texture))
        }
        super.init(adjacency: .adjacencyAll, tileDefinitions: tileDefinitions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func characterToTileDefinition(_ character: Character) -> SKTileDefinition {
        return tileDefinitions[String.supportedCharacters.firstIndex(of: character) ?? 0]
    }
}

fileprivate class TextTileGroup: SKTileGroup {
    var textDefinition: TextDefinition {
        guard let textDefinition = rules.first as? TextDefinition else {
            fatalError("Could not cast as TextDefinition")
        }
        return textDefinition
    }
    
    init(fontType: FontType) {
        let textDefinition = TextDefinition(fontType: fontType)
        super.init(rules: [textDefinition])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func characterToTileDefinition(_ character: Character) -> SKTileDefinition {
        return textDefinition.characterToTileDefinition(character)
    }
}

class TextTileSet: SKTileSet {
    static let shared = TextTileSet()
    
    override private init() {
        let timeStarted = DispatchTime.now()
    
        var tileGroups = [TextTileGroup]()
        for fontType in FontType.allCases {
            tileGroups.append(TextTileGroup(fontType: fontType))
        }
        super.init(tileGroups: tileGroups)
    
        let timeFinished = DispatchTime.now()
        let time = timeFinished.uptimeNanoseconds - timeStarted.uptimeNanoseconds
        print("TextTileSet init: \(Double(time)/1000000)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
