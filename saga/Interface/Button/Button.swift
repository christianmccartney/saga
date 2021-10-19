//
//  Button.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

public typealias ButtonAction = (() -> Void)

class Button: SKSpriteNode {
    var type: ButtonType
    var action: ButtonAction

    public init(type: ButtonType, action: @escaping ButtonAction) {
        let texture = SKTexture(imageNamed: type.rawValue)
        texture.filteringMode = .nearest
        self.type = type
        self.action = action
        super.init(texture: texture, color: .clear, size: texture.size())
        self.isUserInteractionEnabled = true
        self.name = type.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        action()
    }
}
