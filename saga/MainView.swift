//
//  main.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import SwiftUI
import SpriteKit

class Context {
    var coreScene: CoreScene?

    func scene(size: CGSize) -> CoreScene {
        CoreScene.screenSizeRect = CGRect(
            x: ((size.width  * 0.5) * -1.0),
            y: ((size.height * 0.5) * -1.0),
            width: size.width,
            height: size.height)
        if let coreScene = coreScene {
            return coreScene
        }
        let scene = CoreScene()
        scene.size = size
        scene.scaleMode = .aspectFill
        coreScene = scene
        return scene
    }
}

@main
struct MainView: App {
    let context = Context()
    var body: some Scene {
        WindowGroup {
            GeometryReader { (geometry) in
//                let context = FMContext(size: geometry.size)
//                FileStructureView().environmentObject(context)
//                ZStack(alignment: .top) {
                SpriteView(scene: context.scene(size: geometry.size))
//                    PrototypeNumberView(size: geometry.size)
//                }
            }
        }
    }
}
