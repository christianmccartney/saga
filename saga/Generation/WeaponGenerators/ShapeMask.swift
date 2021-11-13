//
//  ShapeMask.swift
//  saga
//
//  Created by Christian McCartney on 10/31/21.
//

import CoreGraphics

protocol ShapeMask {
//    var area: CGSize { get }
    func contains(_ point: CGPoint) -> Bool
}

struct TriangleMask: ShapeMask {
    let a: CGPoint
    let b: CGPoint
    let c: CGPoint
    
    // need axis aligned bounding box of triangle
//    var area: CGSize { CGSize(width: , height: ) }
    
    func contains(_ point: CGPoint) -> Bool {
        let area = 0.5 * (-b.y*c.x + a.y*(-b.x + c.x) + a.x*(b.y - c.y) + b.x*c.y)
        let s = 1/(2*area)*(a.y*c.x - a.x*c.y + (c.y - a.y)*point.x + (a.x - c.x)*point.y)
        let t = 1/(2*area)*(a.x*b.y - a.y*b.x + (a.y - b.y)*point.x + (b.x - a.x)*point.y)
        return s > 0 && t > 0 && (1 - s - t) > 0
    }
}

struct RectangleMask: ShapeMask {
    let a: CGPoint
    let b: CGPoint
    
//    var area: CGSize { CGSize(width: b.x - a.x, height: b.y - a.y) }
    
    func contains(_ point: CGPoint) -> Bool {
        return point.x > a.x && point.x < b.x && point.y > a.y && point.y < b.y
    }
}

struct CircleMask: ShapeMask {
    let a: CGPoint
    let radius: CGFloat

    // less sqrt maybe
    func contains(_ point: CGPoint) -> Bool {
        return (radius * radius) <= ((point.x - a.x) * (point.x - a.x)) + ((point.y - a.y) * (point.y - a.y))
    }
}
