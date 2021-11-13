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
    var actionOff: ButtonAction?
    var toggleable: Bool
    
    private let regularTexture: SKTexture
    private let pressedTexture: SKTexture
    public private(set) var isPressed = false

    public init(type: ButtonType, toggleable: Bool = false, action: @escaping ButtonAction, actionOff: ButtonAction? = nil) {
        self.regularTexture = SKTexture(imageNamed: type.rawValue)
        regularTexture.filteringMode = .nearest
        self.pressedTexture = SKTexture(imageNamed: type.rawValue + "_press")
        pressedTexture.filteringMode = .nearest
        self.type = type
        self.action = action
        self.actionOff = actionOff
        self.toggleable = toggleable
        super.init(texture: regularTexture, color: .clear, size: regularTexture.size())
        self.isUserInteractionEnabled = true
        self.name = type.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func toggle() {
        if toggleable {
            if isPressed {
                toggleOff()
            } else {
                toggleOn()
            }
        }
    }
    
    public func toggleOn() {
        isPressed = true
        action(self)
        texture = pressedTexture
    }
    
    public func toggleOff() {
        isPressed = false
        actionOff?(self)
        texture = regularTexture
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if toggleable {
            toggle()
        } else {
            texture = pressedTexture
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !toggleable {
            action(self)
            texture = regularTexture
        }
    }
}
