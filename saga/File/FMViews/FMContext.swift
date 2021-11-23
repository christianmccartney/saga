//
//  FMContext.swift
//  saga
//
//  Created by Christian McCartney on 10/24/21.
//

import SwiftUI
import Combine

struct ApplyColorAction {
    let color: PixelRGBU8
    let x: Int
    let y: Int
}

enum BrushType {
    case paint
    case fill
}

class FMContext: ObservableObject {
    @Published var size: CGSize
//    @Published var url: URL?
//    @Published private(set) var activeImage: UIImage?
    @Published var selectedColor: PixelRGBU8?
    
    @Published var brushType: BrushType = .paint
    
    private var undoStack = [ApplyColorAction]()
    private var redoStack = [ApplyColorAction]()

//    @Published private(set) var bitmap: Bitmap?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var activeNode: FMNode?

    public init(size: CGSize) {
        self.size = size
//        if let image = FM.shared.firstImageFound? {
//            setActiveImage(image: image)
//        }
    
//        $activeImage.sink { [weak self] image in
//            guard let self = self, let image = image else { return }
//            if let bmp = Bitmap(uiImage: image) {
//                self.bitmap = bmp
//            }
//        }.store(in: &cancellables)
//        $url.sink { [weak self] url in
//            guard let self = self else { return }
//            self.undoStack = []
//            self.redoStack = []
//        }.store(in: &cancellables)
    }

//    func setActiveImage(url: URL) {
//        let image = UIImage(contentsOfFile: url.path)
//        self.url = url
//        activeImage = image
//    }
    
//    func setActiveImage(image: UIImage) {
//        activeImage = image
//    }
    
//    func clearActiveImage() {
////        self.url = nil
//        activeImage = nil
//        bitmap = nil
//    }

    let colors: [PixelRGBU8] = [PixelRGBU8(236, 79, 71, 255),
                                PixelRGBU8(172, 203, 75, 255),
                                PixelRGBU8(82, 161, 236, 255),
                                PixelRGBU8(222, 141, 69, 255),]
//                                PixelRGBU8(181, 64, 191, 255),]

    var index = 0
    func applyBlueprint(_ blueprint: Blueprint, image: inout FMImage) {
        var newImage: UIImage? = nil
        let sortedShaped = blueprint.shapes.sorted { $0.z < $1.z }
        let s = image.image.scale
        let o = image.image.imageOrientation
        
        for shape in sortedShaped {
            let color = shape.color.color
            for x in 0..<image.bmp.width {
                for y in 0..<image.bmp.height {
                    if shape.contains(CGPoint(x: CGFloat(x) / CGFloat(image.bmp.width),
                                              y: CGFloat(y) / CGFloat(image.bmp.height))) {
                        newImage = image.bmp.setPixel(x: x, y: y, color: color, scale: s, orientation: o)
                    }
                }
            }
        }
        if let newImage = newImage {
            image.image = newImage
        }
        index = (index + 1) % colors.count
    }
    
    // This doesnt work
    func applyColor(to image: inout FMImage, color: PixelRGBU8) {
        for x in 0..<image.bmp.width {
            for y in 0..<image.bmp.height {
                applyColor(to: &image, x: x, y: y, color: color)
            }
        }
    }

    func applyColor(to image: inout FMImage, x: Int, y: Int, color: PixelRGBU8, undoable: Bool = true) {
        func apply(bmp: Bitmap, x: Int, y: Int, color: PixelRGBU8, scale: CGFloat, orientation: UIImage.Orientation) -> UIImage? {
            return bmp.setPixel(x: x, y: y, color: color, scale: scale, orientation: orientation)
        }
        
        func recursivelyFill(bmp: Bitmap, x: Int, y: Int, newColor: PixelRGBU8, oldColor: PixelRGBU8, scale: CGFloat, orientation: UIImage.Orientation, depth d: Int) -> UIImage? {
            var pixelsFilled = 0
            var newImage: UIImage?
            for i in max(x-d, 0)...min(x+d, bmp.width) {
                let upperY = min(y+d, bmp.height)
                let lowerY = max(y-d, 0)
                if bmp.getPixel(x: i, y: upperY) == oldColor {
                    pixelsFilled += 1
                    newImage = apply(bmp: bmp, x: i, y: upperY, color: newColor, scale: scale, orientation: orientation)
                }
                if bmp.getPixel(x: i, y: lowerY) == oldColor {
                    pixelsFilled += 1
                    newImage = apply(bmp: bmp, x: i, y: lowerY, color: newColor, scale: scale, orientation: orientation)
                }
            }
            for j in max(y-d+1, 0)...min(y+d-1, bmp.height) {
                let upperX = min(x+d, bmp.width)
                let lowerX = max(x-d, 0)
                if bmp.getPixel(x: upperX, y: j) == oldColor {
                    pixelsFilled += 1
                    newImage = apply(bmp: bmp, x: upperX, y: j, color: newColor, scale: scale, orientation: orientation)
                }
                if bmp.getPixel(x: lowerX, y: j) == oldColor {
                    pixelsFilled += 1
                    newImage = apply(bmp: bmp, x: lowerX, y: j, color: newColor, scale: scale, orientation: orientation)
                }
            }
            if pixelsFilled > 0 {
                if let image = recursivelyFill(bmp: bmp, x: x, y: y, newColor: newColor, oldColor: oldColor, scale: scale, orientation: orientation, depth: d+1) {
                    return image
                } else if let image = newImage {
                    return image
                }
            }
            return nil
        }
        
        
        let oldColor = image.bmp.getPixel(x: x, y: y)
        if let newImage = apply(bmp: image.bmp, x: x, y: y, color: color,
                                scale: image.image.scale, orientation: image.image.imageOrientation) {
            if undoable {
                undoStack.append(ApplyColorAction(color: oldColor, x: x, y: y))
            } else {
                redoStack.append(ApplyColorAction(color: oldColor, x: x, y: y))
            }
            image.image = newImage
        }
        
        if brushType == .fill {
            if let newImage = recursivelyFill(bmp: image.bmp, x: x, y: y, newColor: color, oldColor: oldColor,
                                              scale: image.image.scale, orientation: image.image.imageOrientation, depth: 1) {
                image.image = newImage
            }
        }
    }

    func undo() {
//        if let action = undoStack.popLast() {
//            applyColor(x: action.x, y: action.y, color: action.color, undoable: false)
//        }
    }

    func redo() {
//        if let action = redoStack.popLast() {
//            applyColor(x: action.x, y: action.y, color: action.color, undoable: true)
//        }
    }

    func save() {
//        if let bmp = bitmap, let url = url {
//            print("Write to \(url) \(bmp.writePng(url: url) ? "succeeded " : "failed")")
//        }
    }
}
