//
//  FileManager.swift
//  saga
//
//  Created by Christian McCartney on 10/23/21.
//

import Foundation
import UIKit

enum Directory: String, CaseIterable {
    case images = "images"
    case images_weapons = "images/weapons"
    case images_weapons_swods = "images/weapons/swords"
    
    static var set: Set<Directory> { return Set<Directory>(allCases) }

    static var allPathComponents: [Directory: [String]] {
        var allPathComponents = [Directory: [String]]()
        for directory in Directory.allCases {
            allPathComponents[directory] = directory.rawValue.components(separatedBy: "/")
        }
        return allPathComponents
    }
}

enum FileType: String {
    case png = "png"
}

final class FM {
    static let shared = FM()
    
    let baseNode: DirectoryNode
    
    var expectedFolders: Set<Directory> = Directory.set
    weak var firstImageFound: FileNode?

    private init() {
        guard let baseURL = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first else {
            fatalError("Could not resolve base url")
        }
        self.baseNode = DirectoryNode(url: baseURL)
        checkDirectory(parentNode: baseNode, depth: 0)
    }

    
    private func checkDirectory(parentNode: FMNode, depth: Int) {
        let url = parentNode.url
        var names: Set<String>
        do {
            names = Set<String>(try FileManager.default.contentsOfDirectory(atPath: url.path))
        } catch {
            fatalError("Could not get directories at path: \(url) with error: \(error)")
        }
        
        for expectedFolder in expectedFolders {
            guard let pathComponents = Directory.allPathComponents[expectedFolder] else { continue }
            guard depth == pathComponents.count-1 else { continue }
            let directoryName = pathComponents[depth]
            let newPath = url.path + "/" + directoryName
            let newURL = URL(fileURLWithPath: newPath)
            if names.contains(directoryName) {
                var isDirectory: ObjCBool = true
                if FileManager.default.fileExists(atPath: newPath, isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        let childNode = DirectoryNode(url: newURL)
                        parentNode.addChild(childNode)
                        expectedFolders.remove(expectedFolder)
                        print("Found directory at url: \(newURL)")
                        checkDirectory(parentNode: childNode, depth: depth + 1)
                    }
                }
                names.remove(directoryName)
            } else {
                print("Creating directory at url: \(newURL) with name: \(directoryName)")
                createDirectory(at: newURL)
                let childNode = DirectoryNode(url: newURL)
                parentNode.addChild(childNode)
                expectedFolders.remove(expectedFolder)
                checkDirectory(parentNode: childNode, depth: depth + 1)
            }
        }
        for name in names {
            let newPath = url.path + "/" + name
            let newURL = URL(fileURLWithPath: newPath)
            var isDirectory: ObjCBool = true
            if FileManager.default.fileExists(atPath: newPath,
                                              isDirectory: &isDirectory) {
                if !isDirectory.boolValue {
                    let fileNode = FileNode(url: newURL)
                    if self.firstImageFound == nil {
                        self.firstImageFound = fileNode
                    }
                    parentNode.addChild(fileNode)
                }
            }
        }
    }

    private func createDirectory(at url: URL) {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        } catch {
            fatalError("Could not create directory: \(url) with error: \(error)")
        }
    }

//    func getFile(of type: FileType, to url: URL, node: FMNode) -> UIImage? {
//        if FileManager.default.file
//    }

    func addFile(of type: FileType, to url: URL, node: FMNode, overwrite: Bool = false) -> FileNode? {
        var shouldMakeNode = false
        
        if overwrite {
            if FileManager.default.fileExists(atPath: url.path) {
                FM.shared.delete(node: node, url: url)
            }
        }
        if !FileManager.default.fileExists(atPath: url.path) {
            shouldMakeNode = true
        }
        let bmp = Bitmap(width: STANDARD_WEAPON_WIDTH, height: STANDARD_WEAPON_HEIGHT)
        bmp.generate(closure: { x, y in
//            var r: Float = 0
//            var g: Float = 0
//            var b: Float = 0
//
//            if x == 0, y == 0 {
//                r = 1
//            }
//            if x == 15, y == 0 {
//                g = 1
//            }
//            if x == 0, y == 15 {
//                b = 1
//            }
//            if x == 15, y == 15 {
//                r = 0.5
//                g = 0.5
//                b = 0.5
//            }
            return PixelRGBU8(r: 255, g: 255, b: 255)
//            return PixelRGBU8(r: Float(x % 2), g: Float(y % 2), b: 1.0)
        })
        if bmp.writePng(url: url) {
            print("Wrote png to \(url)")
            if shouldMakeNode {
                let fileNode = FileNode(url: url)
                node.addChild(fileNode)
                return fileNode
            }
//            if let image = UIImage(contentsOfFile: url.path) {
//                return FMImage(image: image, bmp: bmp)
//            }
            return node.children.first { $0.url == url } as? FileNode
        }
        
        return nil
    }

    func writeImage(image: UIImage, to url: URL) -> Bool {
        if let data = image.pngData() {
            do {
                try data.write(to: url)
            } catch {
                print("Failed to write to \(url)")
                return false
            }
        }
        return true
    }

    func delete(node: FMNode, url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            FM.shared.baseNode.removeChild(node)
        } catch {
            print("Failed to delete file at \(url) with \(error)")
        }
    }
}
