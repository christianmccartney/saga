//
//  Easing.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import Foundation
import CoreGraphics
import SpriteKit

enum Curve {
    case cubic
    case quintic
    case bounce
//    case exponential
}

enum Easing<T: FloatingPoint> {
    struct Point<T: FloatingPoint> {
        var x: T
        var y: T
        
        init(_ x: T, _ y: T) {
            self.x = x
            self.y = y
        }
        
        static func *(_ lhs: T, _ rhs: Point) -> Point {
            return Point(rhs.x * lhs, rhs.y * lhs)
        }
        
        static func *(_ lhs: Point, _ rhs: T) -> Point {
            return Point(lhs.x * rhs, lhs.y * rhs)
        }
    
        static func +(_ lhs: Point, _ rhs: Point) -> Point {
            return Point(lhs.x + rhs.x, lhs.y + rhs.y)
        }
    }

    case easeIn
    case easeOut
    case easeInOut
    case easeOutIn
    
    func curve(_ curve: Curve) -> (T) -> T {
        switch curve {
        case .cubic:
            switch self {
            case .easeIn:
                return cubicEaseIn
            case .easeOut:
                return cubicEaseOut
            case .easeInOut:
                return cubicEaseInOut
            case .easeOutIn:
                return cubicEaseOutIn
            }
        case .quintic:
            switch self {
            case .easeIn:
                return quinticEaseIn
            case .easeOut:
                return quinticEaseOut
            case .easeInOut:
                return quinticEaseInOut
            case .easeOutIn:
                return quinticEaseOutIn
            }
//        case .exponential:
//            switch self {
//            case .easeIn:
//                return exponentialEaseIn
//            case .easeOut:
//                return exponentialEaseOut
//            case .easeInOut:
//                return exponentialEaseInOut
//            }
        case .bounce:
            switch self {
            case .easeIn:
                return bounceEaseIn
            case .easeOut:
                return bounceEaseOut
            case .easeInOut:
                return bounceEaseInOut
            case .easeOutIn:
                return bounceEaseIn
            }
        }
    }

    func timingFunction(_ curve: Curve) -> SKActionTimingFunction where T == Float {
        switch curve {
        case .cubic:
            switch self {
            case .easeIn:
                return cubicEaseIn
            case .easeOut:
                return cubicEaseOut
            case .easeInOut:
                return cubicEaseInOut
            case .easeOutIn:
                return cubicEaseOutIn
            }
        case .quintic:
            switch self {
            case .easeIn:
                return quinticEaseIn
            case .easeOut:
                return quinticEaseOut
            case .easeInOut:
                return quinticEaseInOut
            case .easeOutIn:
                return quinticEaseOutIn
            }
//        case .exponential:
//            switch self {
//            case .easeIn:
//                return exponentialEaseIn
//            case .easeOut:
//                return exponentialEaseOut
//            case .easeInOut:
//                return exponentialEaseInOut
//            }
        case .bounce:
            switch self {
            case .easeIn:
                return bounceEaseIn
            case .easeOut:
                return bounceEaseOut
            case .easeInOut:
                return bounceEaseInOut
            case .easeOutIn:
                return bounceEaseIn
            }
        }
    }

    // MARK: Cubic
    
    private func cubicEaseIn(_ x: T) -> T {
        return x * x * x
    }
    
    private func cubicEaseOut(_ x: T) -> T {
        let p = x - 1
        return  p * p * p + 1
    }
    
    private func cubicEaseInOut(_ x: T) -> T {
        if x < 1 / 2 {
            return 4 * x * x * x
        } else {
            let f = 2 * x - 2
            return 1 / 2 * f * f * f + 1
        }
    }
    
    private func cubicEaseOutIn(_ x: T) -> T {
//        if x < 1 / 2 {
//            let f = 2 * x - 2
//            let g = f * f * f
//            return g * (1 / 2) + 1
//        } else {
//            let f = x * x * x
//            let g = f * 4
//            return g
//        }
        let a = (1 - x)
        let b = a * a
        let c = a * a * a
        
        let d: T = 0
        let e: T = 1
        let f: T = 1
        let g: T = 0
        
        let p0 = Point(d, d)
        let p1 = Point(d, e)
        let p2 = Point(f, g)
        let p3 = Point(f, f)
        
        let f1 = c * p0
        let f2 = 3 * b * x * p1
        let f3 = 3 * a * x * x * p2
        let f4 = x * x * x * p3
        
        let h = f1 + f2 + f3 + f4
        return h.y
    }

    // MARK: Quintic
    private func quinticEaseIn(_ x: T) -> T {
        return x * x * x * x * x
    }
    
    private func quinticEaseOut(_ x: T) -> T {
        let f = x - 1
        return f * f * f * f * f + 1
    }

    private func quinticEaseInOut(_ x: T) -> T {
        if x < 1 / 2 {
            return 16 * x * x * x * x * x
        } else {
            let f = 2 * x - 2
            let g = f * f * f * f * f
            return 1 / 2 * g + 1
        }
    }

    private func quinticEaseOutIn(_ x: T) -> T {
        if x < 1 / 2 {
            let f = (x * ( 1 / 2)) - 1
            let g = f * f * f * f * f + 1
            return g
        } else {
            let f = x * x * x * x * x
            let g = f * (1 / 2)
            return g + 1 / 2
        }
    }
    
    // MARK: Bounce
    
    private func bounceEaseIn(_ x: T) -> T {
        return 1 - bounceEaseOut(1 - x)
    }

    private func bounceEaseOut(_ x: T) -> T {
        if x < 4 / 11 {
            return (121 * x * x) / 16
        } else if x < 8 / 11 {
            let f = (363 / 40) * x * x
            let g = (99 / 10) * x
            return f - g + (17 / 5)
        } else if x < 9 / 10 {
            let f = (4356 / 361) * x * x
            let g = (35442 / 1805) * x
            return  f - g + 16061 / 1805
        } else {
            let f = (54 / 5) * x * x
            let g = (513 / 25) * x
            return f - g + 268 / 25
        }
    }

    private func bounceEaseInOut(_ x: T) -> T {
        if x < 1 / 2 {
            return 1 / 2 * bounceEaseIn(2 * x)
        } else {
            let f = 1 / 2 * bounceEaseOut(x * 2 - 1)
            return f + 1 / 2
        }
    }

    // MARK: Exponential
//    private func exponentialEaseIn(_ x: T) -> T {
//        return x == 0 ? x : pow(2, 10 * (x - 1))
//    }
//
//    private func exponentialEaseOut(_ x: T) -> T {
//        return x == 1 ? x : 1 - pow(2, -10 * x)
//    }
//
//    private func exponentialEaseInOut(_ x: T) -> T {
//        if x == 0 || x == 1 {
//            return x
//        }
//
//        if x < 1 / 2 {
//            return 1 / 2 * pow(2, 20 * x - 10)
//        } else {
//            let h = pow(2, -20 * x + 10)
//            return -1 / 2 * h + 1
//        }
//    }
}
