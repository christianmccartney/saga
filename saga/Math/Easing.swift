//
//  Easing.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import Foundation
import CoreGraphics

enum Curve {
    case quintic
    case exponential
}

enum Easing {
    case easeIn
    case easeOut
    case easeInOut
    func curve(_ curve: Curve) -> (CGFloat) -> CGFloat {
        switch curve {
        case .quintic:
            switch self {
            case .easeIn:
                return quinticEaseIn
            case .easeOut:
                return quinticEaseOut
            case .easeInOut:
                return quinticEaseInOut
            }
        case .exponential:
            switch self {
            case .easeIn:
                return exponentialEaseIn
            case .easeOut:
                return exponentialEaseOut
            case .easeInOut:
                return exponentialEaseInOut
            }
        }
    }

    // MARK: Quintic
    private func quinticEaseIn(_ x: CGFloat) -> CGFloat {
        return x * x * x * x * x
    }
    
    private func quinticEaseOut(_ x: CGFloat) -> CGFloat {
        let f = x - 1
        return f * f * f * f * f + 1
    }

    private func quinticEaseInOut(_ x: CGFloat) -> CGFloat {
        if x < 1 / 2 {
            return 16 * x * x * x * x * x
        } else {
            let f = 2 * x - 2
            let g = f * f * f * f * f
            return 1 / 2 * g + 1
        }
    }

    // MARK: Exponential
    private func exponentialEaseIn(_ x: CGFloat) -> CGFloat {
        return x == 0 ? x : pow(2, 10 * (x - 1))
    }

    private func exponentialEaseOut(_ x: CGFloat) -> CGFloat {
        return x == 1 ? x : 1 - pow(2, -10 * x)
    }
        
    private func exponentialEaseInOut(_ x: CGFloat) -> CGFloat {
        if x == 0 || x == 1 {
            return x
        }

        if x < 1 / 2 {
            return 1 / 2 * pow(2, 20 * x - 10)
        } else {
            let h = pow(2, -20 * x + 10)
            return -1 / 2 * h + 1
        }
    }
}
