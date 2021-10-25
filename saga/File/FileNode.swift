//
//  FileNode.swift
//  saga
//
//  Created by Christian McCartney on 10/23/21.
//

import Foundation

public enum FMNodeType {
    case none
    case directory
    case file
}

open class FMNode: Identifiable {
    public let id = UUID()
    let url: URL
    let type: FMNodeType
    var children = [FMNode]()

    public init(url: URL, type: FMNodeType = .none) {
        self.url = url
        self.type = type
    }

    func addChild(_ node: FMNode) {
        children.append(node)
    }
}

extension FMNode: Equatable {
    public static func == (lhs: FMNode, rhs: FMNode) -> Bool {
        return lhs.url == lhs.url && lhs.children == rhs.children
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
    public override init(url: URL, type: FMNodeType = .file) {
        super.init(url: url, type: type)
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
