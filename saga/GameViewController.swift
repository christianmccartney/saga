//
//  GameViewController.swift
//  saga
//
//  Created by Christian McCartney on 10/8/21.
//

import UIKit
import SpriteKit
import GameplayKit

var screenSize: CGSize!
var screenSizeRect: CGRect!

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "CoreScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! CoreScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    screenSize = view.bounds.size
                    screenSizeRect = getScreenSizeRect()
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    func getScreenSizeRect() -> CGRect {
        return CGRect(x: ((screenSize.width  * 0.5) * -1.0), y: ((screenSize.height * 0.5) * -1.0), width: screenSize.width, height: screenSize.height)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
