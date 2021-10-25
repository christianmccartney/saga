//
//  CGPoint.swift
//  Saga
//
//  Created by Christian McCartney on 5/19/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {

    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
    }

    static func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
        return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
    }

    static func avg(_ left: CGPoint, _ right: CGPoint) -> CGPoint {
        return CGPoint(x: (left.x + right.x) / 2, y: (left.y + right.y) / 2)
    }

    static func * (point: CGPoint, scalar: Double) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
}
