//
//  TextTileSet.swift
//  saga
//
//  Created by Christian McCartney on 11/23/21.
//

import SpriteKit

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
