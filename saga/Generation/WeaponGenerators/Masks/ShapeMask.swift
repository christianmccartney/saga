//
//  ShapeMask.swift
//  saga
//
//  Created by Christian McCartney on 10/31/21.
//

import CoreGraphics
import SwiftUI

protocol ShapeMask {
    var path: UIBezierPath { get }
    var z: Int { get }
    var color: ShapeColor { get }
    func contains(_ point: CGPoint, _ scale: CGVector) -> Bool
}

extension ShapeMask {
    func contains(_ point: CGPoint) -> Bool {
        path.contains(point)
    }
}

// This seems bad, delete this probably
struct LineMask: ShapeMask {
    var path: UIBezierPath
    var a: CGPoint
    var b: CGPoint
    var z: Int
    var color: ShapeColor

    init(a: CGPoint, b: CGPoint, z: Int = 0, color: ShapeColor = .clear) {
        let path = UIBezierPath(rect: CGRect(a, b))
        self.path = path
        self.a = a
        self.b = b
        self.z = z
        self.color = color
    }

    func contains(_ point: CGPoint, _ scale: CGVector) -> Bool {
        var aOffset = CGPoint(x: 0, y: 0)
        var bOffset = CGPoint(x: 0, y: 0)
        if a.y == b.y {
            aOffset = CGPoint(x: 0.0, y: 1.0)
        } else if a.x == b.x {
            bOffset = CGPoint(x: 1.0, y: 0.0)
        }
        let path = UIBezierPath(rect: CGRect((a * scale) - aOffset, (b * scale) - bOffset))
        return path.contains(point)
    }
}

struct TriangleMask: ShapeMask {
    let path: UIBezierPath
    let z: Int
    let color: ShapeColor
    
    init(a: CGPoint, b: CGPoint, c: CGPoint, z: Int = 0, color: ShapeColor = .clear) {
        let path = UIBezierPath()
        path.move(to: a)
        path.addLine(to: b)
        path.addLine(to: c)
        self.path = path
        self.z = z
        self.color = color
    }
    
    func contains(_ point: CGPoint, _ scale: CGVector) -> Bool {
        path.contains(point * scale)
    }
}

struct RectangleMask: ShapeMask {
    let path: UIBezierPath
    let z: Int
    let color: ShapeColor
    
    init(a: CGPoint, b: CGPoint, z: Int = 0, color: ShapeColor = .clear) {
        let path = UIBezierPath(rect: CGRect(a, b))
        self.path = path
        self.z = z
        self.color = color
    }
    
    func contains(_ point: CGPoint, _ scale: CGVector) -> Bool {
        path.contains(point * scale)
    }
}

struct CircleMask: ShapeMask {
    let path: UIBezierPath
    let z: Int
    let color: ShapeColor

    init(center: CGPoint, radius: CGFloat, startAngle: CGFloat = 0.0, endAngle: CGFloat = 2 * CGFloat.pi, clockwise: Bool = true, z: Int = 0, color: ShapeColor) {
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        self.z = z
        self.color = color
    }
    
    func contains(_ point: CGPoint, _ scale: CGVector) -> Bool {
        path.contains(point * scale)
    }
}

struct BezierMask: ShapeMask {
    let path: UIBezierPath
    let z: Int
    let color: ShapeColor
    
    init(start: CGPoint, points: [(CGPoint, CGPoint?)], z: Int = 0, color: ShapeColor) {
        self.path = UIBezierPath()
        path.move(to: start)
        for (end, control) in points {
            if let control = control {
                path.addQuadCurve(to: end, controlPoint: control)
            } else {
                path.addLine(to: end)
            }
        }
        path.close()
        self.z = z
        self.color = color
    }

    init(start: CGPoint, points: [(CGPoint, CGPoint?, CGPoint?)], z: Int = 0, color: ShapeColor) {
        self.path = UIBezierPath()
        path.move(to: start)
        for (end, control1, control2) in points {
            if let control1 = control1 {
                if let control2 = control2 {
                    path.addCurve(to: end, controlPoint1: control1, controlPoint2: control2)
                } else {
                    path.addQuadCurve(to: end, controlPoint: control1)
                }
            } else {
                path.addLine(to: end)
            }
        }
        path.close()
        self.z = z
        self.color = color
    }
    
    func contains(_ point: CGPoint, _ scale: CGVector) -> Bool {
        path.contains(point * scale)
    }
}
