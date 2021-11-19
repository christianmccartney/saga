//
//  Node.swift
//  saga
//
//  Created by Christian McCartney on 10/12/21.
//

import SpriteKit

public protocol NodeDelegate: AnyObject {
    func touchDown(_ pos: CGPoint)
    func touchMoved(_ pos: CGPoint)
    func touchUp(_ pos: CGPoint)
}

public class Node: SKSpriteNode {
    weak var nodeDelegate: NodeDelegate?
    
    public init(texture: SKTexture) {
        super.init(texture: texture, color: .clear, size: texture.size())
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { nodeDelegate?.touchDown(t.location(in: self)) }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { nodeDelegate?.touchMoved(t.location(in: self)) }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { nodeDelegate?.touchUp(t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { nodeDelegate?.touchUp(t.location(in: self)) }
    }

    public func copy() -> Node {
        return Node(texture: self.texture ?? SKTexture(imageNamed: ""))
    }

    @MainActor
    func addChild(_ emitter: Emitter) {
        for child in emitter.emitters {
            addChild(child)
        }
    }

    @MainActor
    func removeChild(_ emitter: Emitter) {
        removeChildren(in: emitter.emitters)
    }
}
