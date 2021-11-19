//
//  BottomBar.swift
//  Saga
//
//  Created by Christian McCartney on 5/30/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class BottomBar: InterfaceElement {
    public init(tileSet: SKTileSet, columns: Int, rows: Int) {
        super.init(
            tileSet: tileSet,
            columns: columns,
            rows: rows,
            tileSize: tileSet.defaultTileSize)
        anchorPoint = CGPoint(x: 0.5, y: 0.0)
        enableAutomapping = false
        fillWithEdges(tileSet.tileGroups.first!)
        
        let swordButton = Button(type: .sword, toggleable: true, action: { [weak self] button in
            guard let self = self else { return }
            self.coreScene?.playerEntity?.selectedAbility = strAttack
            self.toggleOthers(button: button)
        }, actionOff: { [weak self] _ in self?.resetAbility() })
    
        let dashButton = Button(type: .arrow_right, toggleable: true, action: { [weak self] button in
            guard let self = self else { return }
            self.coreScene?.playerEntity?.selectedAbility = dash
            self.toggleOthers(button: button)
        }, actionOff: { [weak self] _ in self?.resetAbility() })
        
        let fireball = Ability(name: "fireball",
                               targets: [.enemy, .neutral, .none],
                               abilityChecker: IntelligenceDamageAbilityChecker(),
                               abilityTextureName: EffectType.fireball.rawValue,
                               abilityAnimation: fireballAttackAnimation)
        let fireballButton = Button(type: .ability(fireball), toggleable: true, action: { [weak self] button in
            guard let self = self else { return }
            guard case .ability(let ability) = button.type else { return }
            self.coreScene?.playerEntity?.selectedAbility = ability
            self.toggleOthers(button: button)
        }, actionOff: { [weak self] _ in self?.resetAbility() })
        
        let voidball = Ability(name: "voidball",
                               targets: [.enemy, .neutral, .none],
                               abilityChecker: IntelligenceDamageAbilityChecker(),
                               abilityTextureName: EffectType.voidball.rawValue,
                               abilityAnimation: voidballAttackAnimation)
        
        let voidballButton = Button(type: .ability(voidball), toggleable: true, action: { [weak self] button in
            guard let self = self else { return }
            guard case .ability(let ability) = button.type else { return }
            self.coreScene?.playerEntity?.selectedAbility = ability
            self.toggleOthers(button: button)
        }, actionOff: { [weak self] _ in self?.resetAbility() })
        
        self.buttons = [swordButton, dashButton, fireballButton, voidballButton]
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func toggleOthers(button: Button) {
        if button.isPressed {
            self.buttons.forEach { if $0 != button { $0.toggleOff() } }
        }
    }

    private func resetAbility() {
        if self.buttons.allSatisfy({ !$0.isPressed }) {
            self.coreScene?.playerEntity?.selectedAbility = nil
        }
    }
    
    override func setupButtons() {
        var x = 0
        for button in buttons {
            addChild(button)
            let center1 = (centerOfTile(atColumn: x, row: 0) + centerOfTile(atColumn: x, row: 1)) / 2
            let center2 = (centerOfTile(atColumn: x + 1, row: 0) + centerOfTile(atColumn: x + 1, row: 1)) / 2
            button.position = (center1 + center2) / 2
            button.setScale(1.5)
            x += 2
        }
    }

    override func setPosition() {
        posByScreen(x: 0.5, y: 0.01)
    }
}
