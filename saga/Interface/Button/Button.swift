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
    private var abilityNode: SKSpriteNode?

    public init(type: ButtonType, toggleable: Bool = false, action: @escaping ButtonAction, actionOff: ButtonAction? = nil) {
        if case .ability(let ability) = type {
            self.regularTexture = SKTexture(imageNamed: ButtonType.blank.textureName)
            self.pressedTexture = SKTexture(imageNamed: ButtonType.blank.textureName + "_press")
            self.abilityNode = SKSpriteNode(texture: ability.abilityTexture)
        } else {
            self.regularTexture = SKTexture(imageNamed: type.textureName)
            self.pressedTexture = SKTexture(imageNamed: type.textureName + "_press")
        }
        regularTexture.filteringMode = .nearest
        pressedTexture.filteringMode = .nearest
        self.type = type
        self.action = action
        self.actionOff = actionOff
        self.toggleable = toggleable
        super.init(texture: regularTexture, color: .clear, size: regularTexture.size())
        if let abilityNode = abilityNode { self.addChild(abilityNode) }
        self.isUserInteractionEnabled = true
        self.name = type.textureName
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
