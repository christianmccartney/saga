//
//  Button.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

typealias ButtonAction = ((Button) -> Void)

class Button: SKSpriteNode {
    var type: ButtonType
    var action: ButtonAction
    
    private let regularTexture: SKTexture
    private let pressedTexture: SKTexture
    private var isPressed = false

    public init(type: ButtonType, action: @escaping ButtonAction) {
        self.regularTexture = SKTexture(imageNamed: type.rawValue)
        regularTexture.filteringMode = .nearest
        self.pressedTexture = SKTexture(imageNamed: type.rawValue + "_press")
        pressedTexture.filteringMode = .nearest
        self.type = type
        self.action = action
        super.init(texture: regularTexture, color: .clear, size: regularTexture.size())
        self.isUserInteractionEnabled = true
        self.name = type.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        texture = pressedTexture
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        action(self)
        texture = regularTexture
    }
}
