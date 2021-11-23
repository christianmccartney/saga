//
//  SKTexture.swift
//  saga
//
//  Created by Christian McCartney on 11/22/21.
//

import SpriteKit

extension SKTexture {
    convenience init(regularRect: CGRect, inTexture texture: SKTexture) {
        let rect = regularRect.unitRectForSize(size: texture.size())
        self.init(rect: rect, in: texture)
    }
}
