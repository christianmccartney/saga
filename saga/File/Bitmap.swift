//
//  Bitmap.swift
//  saga
//
//  Created by Christian McCartney on 10/23/21.
//

import Foundation
import CoreGraphics
import CoreServices
import ImageIO
import UIKit

struct PixelRGBU8 {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let u: UInt8 // Unused byte, for 32-bit alignment
    
    init(_ r: UInt8, _ g: UInt8, _ b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
        self.u = 0
    }
    
    init(r: Float, g: Float, b: Float) {
        let corrR = max(0.0, min(r, 1.0))
        let corrG = max(0.0, min(g, 1.0))
        let corrB = max(0.0, min(b, 1.0))
        self.init(UInt8(corrR*255.0), UInt8(corrG*255.0), UInt8(corrB*255.0))
    }
    
    var uiColor: UIColor {
        UIColor(red: r, green: g, blue: b, alpha: 255)
    }
}

extension PixelRGBU8: Equatable {}

class Bitmap {
    let width : Int
    let height : Int
    let bitmapContext: CGContext
    let pixels : UnsafeMutableRawPointer
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        let bytesPerRow = width * MemoryLayout<PixelRGBU8>.size
        let size = height * bytesPerRow
        pixels = malloc(size)
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
        bitmapContext = CGContext(data: pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    }

    init?(uiImage: UIImage) {
        guard let inputCGImage = uiImage.cgImage else { return nil }
        self.width = inputCGImage.width
        self.height = inputCGImage.height
        let bytesPerRow = width * MemoryLayout<PixelRGBU8>.size
        let size = height * bytesPerRow
        pixels = malloc(size)
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)
        bitmapContext = CGContext(data: pixels, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!

        bitmapContext.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
    }
    
    deinit {
        free(pixels)
    }
    
    // The closure is given the x and y coordinates in the bitmap;
    // 0, 0 is in the top left corner.
    func generate(closure: (Int, Int) -> PixelRGBU8 ) {
        var pixelIndex = 0
        for y in 0..<height {
            for x in 0..<width {
                let offset = pixelIndex * MemoryLayout<PixelRGBU8>.size
                let pixel = closure(x, y)
                pixels.storeBytes(of: pixel, toByteOffset: offset, as: PixelRGBU8.self)
                pixelIndex += 1
            }
        }
    }
    
    func writePng(url: URL) -> Bool {
        let cgImage = bitmapContext.makeImage()
        guard cgImage != nil else {
            return false
        }
        
        let dest = CGImageDestinationCreateWithURL(url as CFURL, kUTTypePNG, 1, nil)
        guard dest != nil else {
            return false
        }
        
        CGImageDestinationAddImage(dest!, cgImage!, nil)
        return CGImageDestinationFinalize(dest!)
    }

    func setPixel(x: Int, y: Int, color: PixelRGBU8, scale: CGFloat, orientation: UIImage.Orientation) -> UIImage {
        let pixelIndex = x + (y * width)
        let offset = pixelIndex * MemoryLayout<PixelRGBU8>.size
        let pixel = PixelRGBU8(color.r, color.g, color.b)
        pixels.storeBytes(of: pixel, toByteOffset: offset, as: PixelRGBU8.self)

        let outputCGImage = bitmapContext.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage,
                                  scale: scale,
                                  orientation: orientation)
        return outputImage
    }

    func getPixel(x: Int, y: Int) -> PixelRGBU8 {
        let pixelIndex = x + (y * width)
        let offset = pixelIndex * MemoryLayout<PixelRGBU8>.size
        return pixels.load(fromByteOffset: offset, as: PixelRGBU8.self)
    }
}

public extension UIColor {
    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(
            red: CGFloat(red)/255,
            green: CGFloat(green)/255,
            blue: CGFloat(blue)/255,
            alpha: CGFloat(alpha)/255)
    }
}
