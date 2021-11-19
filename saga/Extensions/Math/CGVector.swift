//
//  CGVector.swift
//  saga
//
//  Created by Christian McCartney on 11/14/21.
//

import CoreGraphics
import simd

infix operator **

extension CGVector {
    func angle(to vector: CGVector) -> CGFloat {
        acos(self ** vector)
    }

    var length: CGFloat {
        return sqrt(dx * dx + dy * dy)
    }

    var normalized: CGVector {
        return CGVector(dx: dx / length, dy: dy / length)
    }

    static func **(lhs: CGVector, rhs: CGVector) -> CGFloat {
        return lhs.dx * rhs.dx + lhs.dy * rhs.dy
    }
}
