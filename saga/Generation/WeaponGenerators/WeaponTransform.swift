//
//  WeaponTransform.swift
//  saga
//
//  Created by Christian McCartney on 10/26/21.
//

import CoreGraphics

struct WeaponTransform {
    let xScale: CGFloat
    let yScale: CGFloat
    let masks: [WeaponComponent: ShapeMask]
    let color: PixelRGBU8

    public init(xScale: CGFloat = 1.0,
                yScale: CGFloat = 1.0,
                masks: [WeaponComponent: ShapeMask] = [:],
                color: PixelRGBU8 = .clear) {
        self.xScale = xScale
        self.yScale = yScale
        self.masks = masks
        self.color = color
    }
}
