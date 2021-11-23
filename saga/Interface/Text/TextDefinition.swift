//
//  TextDefinition.swift
//  saga
//
//  Created by Christian McCartney on 11/23/21.
//

import SpriteKit

class TextDefinition: SKTileGroupRule {
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
