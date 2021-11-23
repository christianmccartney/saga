//
//  FMFileViews.swift
//  saga
//
//  Created by Christian McCartney on 10/23/21.
//

import SwiftUI

struct FileStructureView: View {
    @EnvironmentObject var context: FMContext
    @State var activeNode: FMNode?
    @State var isNewFilePresented: Bool = false
    @State var bitmap: Bitmap?

    var body: some View {
        HStack {
            VStack {
                ScrollView {
                    VStack {
                        FMNameView(node: FM.shared.baseNode, indent: 0, activeNode: $activeNode)
                            .border(Color.red)
                        FMNodeView(node: FM.shared.baseNode, indent: 0, activeNode: $activeNode)
                        Spacer()
                    }
                }
                .frame(height: context.size.height/2)
                Divider()
                Spacer()
                Image(systemName: "g.circle")
                    .onTapGesture {
                        guard let activeNode = activeNode else { return }
                        let node: FMNode
                        if activeNode.type == .directory {
                            node = activeNode
                        } else {
                            node = activeNode.parent
                        }
                        for i in 0..<20 {
                            let path = node.url.appendingPathComponent("test_\(i).png")
                            if let file = FM.shared.addFile(of: .png, to: path, node: node) {
                                let definition = WeaponDefinition.randomSword()
                                file.randomImage(with: definition, context: context)
                            }
                        }
                    }
                Spacer()
                Divider()
                FMPaletteView()
            }
            .frame(width: context.size.width/5)
            Divider()
            FMImageCollectionView(bitmap: bitmap, fileNodes: activeNode?.fileNodes ?? [])
        }
        .onChange(of: activeNode) { context.activeNode = $0 }
        .sheet(isPresented: $isNewFilePresented,
               onDismiss: { isNewFilePresented = false },
               content: {
            if let node = activeNode {
                FMNewFileView(node: node, isPresented: $isNewFilePresented)
                    .frame(width: context.size.width/8, height: context.size.height/8)
            }
        })
    }
}

struct FMNodeView: View {
    @EnvironmentObject var context: FMContext
    let node: FMNode
    let indent: Int
    @Binding var activeNode: FMNode?
    @State var collapsed: Bool = false
    
    var body: some View {
        ForEach(node.children, id: \.self) { child in
            if !collapsed {
                VStack {
                    FMNameView(node: child, indent: indent + 1, activeNode: $activeNode)
                    FMNodeView(node: child, indent: indent + 1, activeNode: $activeNode)
                }
            }
        }
        .onReceive(node.$collapsed) { collapsed = $0 }
    }
}

struct FMNameView: View {
    @EnvironmentObject var context: FMContext
    let node: FMNode
    let indent: Int
    @Binding var activeNode: FMNode?
    @State var highlighted: Bool = false
    @State var collapsed: Bool = false
    
    var body: some View {
        HStack {
            if node.type == .directory {
                Image(systemName: collapsed ? "plus.square" : "minus.square")
                    .onTapGesture { node.collapsed.toggle() }
            }
            if node.type == .file {
                Image(systemName: "photo")
            }
            Text(node.url.lastPathComponent)
            Spacer()
            if node.type == .directory {
                Image(systemName: "trash")
                    .onTapGesture {
                        for child in node.children {
                            FM.shared.delete(node: child, url: child.url)
                        }
                    }
            }
            if node.type == .file {
                Image(systemName: "trash")
                    .onTapGesture { FM.shared.delete(node: node, url: node.url) }
            }
        }
        .frame(height: context.size.height / 32)
        .padding(EdgeInsets(top: 0, leading: CGFloat(8 + 8 * indent), bottom: 0, trailing: 8))
        .background(Rectangle().fill(highlighted ? Color.gray.opacity(0.5) : Color.gray.opacity(0.003)))
        .border(node.type == .directory ? Color.blue : Color.green)
        .onReceive(context.$activeNode) { highlighted = $0 == node }
        .onReceive(node.$collapsed) { collapsed = $0 }
        .onTapGesture { activeNode = node }
    }
}
