//
//  CGRect.swift
//  saga
//
//  Created by Christian McCartney on 10/17/21.
//

import SpriteKit

extension CGRect {
    func unitRectForSize(size: CGSize) -> CGRect {
        if 0 > size.width || 0 > size.height {
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        var x = self.origin.x
        var y = self.origin.y
        var width = self.size.width + x
        var height = self.size.height + y
        
        // x
        if 0 > x {
            width += x
            x = 0
        } else if size.width < x {
            x = size.width
            width = size.width
        }
        
        // y
        if 0 > y {
            height += y
            y = 0
        } else if size.height < y {
            y = size.height
            height = size.height
        }
        
        // width
        if 0 > width {
            width = 0
        } else if size.width < width {
            width = size.width
        }
        if width < x {
            width = x
        }
        
        // height
        if 0 > height {
            height = 0
        } else if size.height < height {
            height = size.height
        }
        if height < y {
            height = y
        }
        
        return CGRect(x: x / size.width, y: y / size.height, width: (width - x) / size.width, height: (height - y) / size.height)
    }
}

extension CGRect {
    init(_ p1: CGPoint, _ p2: CGPoint) {
        self.init(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: abs(p1.x - p2.x), height: abs(p1.y - p2.y))
    }
}
