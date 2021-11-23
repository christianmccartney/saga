//
//  CGFloat.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import Foundation
import CoreGraphics

extension CGFloat {
    func map(from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
        let result = ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
        return result
    }
}
