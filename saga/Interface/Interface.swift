//
//  Interface.swift
//  Saga
//
//  Created by Christian McCartney on 5/28/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import SpriteKit

class Interface {
    static let shared = Interface()
    weak var camera: Camera?
    weak var coreScene: CoreScene?
    var elements = [InterfaceElement]()
    var modalElements = [InterfaceElement]()
    var presentedModal: InterfaceElement?

    private init() {
        let stoneInterface = TileSet(InterfaceTileGroupDefinition(name: "stone_a", adjacencyTextureProvider: InterfaceType.stone_a))
        let scrollInterface = TileSet(InterfaceTileGroupDefinition(name: "scroll_a", adjacencyTextureProvider: InterfaceType.scroll_a))
        let windowInterface = TileSet(InterfaceTileGroupDefinition(name: "window", adjacencyTextureProvider: InterfaceType.window))
        
        let bottomBar = BottomBar(tileSet: stoneInterface, columns: 15, rows: 2)
        let healthBar = HealthBar(tileSet: windowInterface, columns: 6, rows: 1)
        let manaBar = ManaBar(tileSet: windowInterface, columns: 6, rows: 1)
        let resourceBars: [InterfaceElement] = [healthBar, manaBar]
        bottomBar.elements = resourceBars
        
        let sideBar = SideBar(tileSet: stoneInterface, columns: 2, rows: 12)
        
        let entityInspector = EntityInspector(tileSet: scrollInterface, columns: 8, rows: 8)
        let entityWindow = EntityWindow(tileSet: windowInterface, columns: 5, rows: 5)
        self.elements = [bottomBar, sideBar, entityInspector, entityWindow]
        
        let equipmentInspector = EquipmentInspector(tileSet: stoneInterface, columns: 20, rows: 16)
//        let headSlot = ItemSlot(tileSet: windowInterface, columns: 2, rows: 2, type: .head)
//        let chestSlot = ItemSlot(tileSet: windowInterface, columns: 4, rows: 4, type: .chest)
//        let rightArmSlot = ItemSlot(tileSet: windowInterface, columns: 3, rows: 2, type: .rightArm)
//        let leftArmSlot = ItemSlot(tileSet: windowInterface, columns: 3, rows: 2, type: .leftArm)
//        let itemSlots: [InterfaceElement] = [headSlot, chestSlot, rightArmSlot, leftArmSlot]
//        equipmentInspector.elements = itemSlots
        self.modalElements = [equipmentInspector]

        for element in elements {
            element.interfaceDelegate = self
        }
        for modalElement in modalElements {
            modalElement.interfaceDelegate = self
        }
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func attachToCamera(_ camera: Camera, _ scene: CoreScene) {
        for element in elements {
            camera.addChild(element)
            element.zPosition = 8
            element.setPosition()
            element.setupButtons()
            element.coreScene = scene
            element.attachElements(scene)
        }
        self.camera = camera
        self.coreScene = scene
    }

    fileprivate func attachToCamera(_ element: InterfaceElement) {
        guard let camera = camera, let scene = coreScene else { return }
        camera.addChild(element)
        element.zPosition = 9
        element.setPosition()
        element.setupButtons()
        element.coreScene = scene
        element.attachElements(scene)
    }

    fileprivate func unattachFromCamera(_ element: InterfaceElement) {
        guard let camera = camera else { return }
        camera.removeChildren(in: [element])
    }

    func setScale(_ scale: CGFloat) {
        for element in elements {
            element.setScale(scale)
        }
        for modalElement in modalElements {
            modalElement.setScale(scale)
        }
    }

    func update() {
        for element in elements {
            element.update()
        }
        for modalElement in modalElements {
            modalElement.update()
        }
    }
}

extension Interface: InterfaceDelegate {
    func addChild(_ entity: Entity) {
        coreScene?.addChild(entity)
    }
    
    func removeChild(_ entity: Entity) {
        coreScene?.removeChild(entity)
    }
    
    func track(_ entity: Entity) {
        coreScene?.track(entity)
    }
    
    func untrack(_ entity: Entity) {
        System.shared.removeEntity(entity)
        coreScene?.untrack(entity)
    }
    
    func unpresentModal() {
        guard let element = presentedModal else { return }
        unattachFromCamera(element)
        presentedModal = nil
    }
    
    func presentModal(_ type: InterfaceElement.Type) {
        func isType<T>(instance: Any, of kind: T.Type) -> Bool { return instance is T }
        guard let element = modalElements.first(where: { isType(instance: $0, of: type) }) else { return }
        guard element != presentedModal else { unpresentModal(); return }
        unpresentModal()
        element.setupButtons()
        presentedModal = element
        attachToCamera(element)
    }
}
