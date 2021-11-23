//
//  FileNode.swift
//  saga
//
//  Created by Christian McCartney on 10/23/21.
//

import UIKit

public enum FMNodeType {
    case none
    case directory
    case file
}

open class FMNode: Identifiable, ObservableObject {
    public let id: UUID
    let url: URL
    let type: FMNodeType
    weak var parent: FMNode!
    @Published var children = [FMNode]()
    @Published var collapsed: Bool = false

    public init(url: URL, type: FMNodeType = .none) {
        self.id = UUID()
        self.url = url
        self.type = type
    }

    func addChild(_ node: FMNode) {
        node.parent = self
        children.append(node)
    }

    func removeChild(_ node: FMNode) {
        if let index = children.firstIndex(of: node) {
            children.remove(at: index)
        } else {
            for child in children {
                child.removeChild(node)
            }
        }
    }

    var images: [FMImage] { fileNodes.map { $0.image } }
    var fileNodes: [FileNode] { children.compactMap { $0 as? FileNode } }
}

extension FMNode: Equatable {
    public static func == (lhs: FMNode, rhs: FMNode) -> Bool {
        return lhs.id == rhs.id && lhs.url == lhs.url && lhs.children == rhs.children
    }
}

extension FMNode: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
        hasher.combine(type)
    }
}

class DirectoryNode: FMNode {
    public override init(url: URL, type: FMNodeType = .directory) {
        super.init(url: url, type: type)
    }
}

class FileNode: FMNode {
    var image: FMImage
    
    public override init(url: URL, type: FMNodeType = .file) {
        let image = UIImage(contentsOfFile: url.path) ?? UIImage()
        guard let bitmap = Bitmap(uiImage: image) else { fatalError("Failed to make bitmap from \(url)") }
        self.image = FMImage(image: image, bmp: bitmap)
        super.init(url: url, type: type)
    }

    func randomImage(with definition: WeaponDefinition, context: FMContext) {
//        image.image = UIImage(contentsOfFile: url.path) ?? image.image
        for blueprint in WeaponGenerator.shared.generateBlueprints(for: definition).sorted(by: { $0.z < $1.z }) {
            context.applyBlueprint(blueprint, image: &image)
        }
    }
}

class FMImage: Hashable, ObservableObject {
    @Published var image: UIImage
    var bmp: Bitmap
    
    init(image: UIImage, bmp: Bitmap) {
        self.image = image
        self.bmp = bmp
    }
    
    static func == (lhs: FMImage, rhs: FMImage) -> Bool {
        return lhs.image == rhs.image
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
    }
}

//public class TreeNode<T>: Equatable where T: Hashable {
//    public var value: T
//
//    public weak var parent: TreeNode?
//    public var children = [TreeNode<T>]()
//
//    public init(value: T) {
//        self.value = value
//    }
//
//    public func addChild(_ node: TreeNode<T>) {
//        children.append(node)
//        node.parent = self
//    }
//}
//
//extension TreeNode: CustomStringConvertible {
//    public var description: String {
//        var s = "\(value)"
//        if !children.isEmpty {
//            s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
//        }
//        return s
//    }
//}
//
//extension TreeNode where T: Equatable {
//    public func search(_ value: T) -> TreeNode? {
//        if value == self.value {
//            return self
//        }
//        for child in children {
//            if let found = child.search(value) {
//                return found
//            }
//        }
//        return nil
//    }
//}
