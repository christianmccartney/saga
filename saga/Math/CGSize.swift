//
//  CGSize.swift
//  Saga
//
//  Created by Christian McCartney on 5/19/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {
    func contains(_ point: CGPoint) -> Bool {
        return point.x > 0 && point.x < self.width && point.y > 0 && point.y < self.height
    }

    func containsX(_ x: CGFloat) -> Bool {
        return x > 0 && x < self.width
    }

    func containsY(_ y: CGFloat) -> Bool {
        return y > 0 && y < self.height
    }

    var smallestDim: CGFloat {
        return min(width, height)
    }
}
