//
//  TextTileGroup.swift
//  saga
//
//  Created by Christian McCartney on 11/23/21.
//

import SpriteKit

class TextTileGroup: SKTileGroup {
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
