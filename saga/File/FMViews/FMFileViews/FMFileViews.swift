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

    var body: some View {
        HStack {
            VStack {
                VStack {
                    FMNameView(node: FM.shared.baseNode, indent: 0, activeNode: $activeNode)
                        .border(Color.red)
                    FMNodeView(node: FM.shared.baseNode, indent: 0, activeNode: $activeNode)
                    Spacer()
                }
                .frame(height: context.size.height/2)
                Divider()
                Spacer()
                Image(systemName: "g.circle")
                    .onTapGesture {
                        let definition = WeaponDefinition(type: .sword,
                                                          components: [.blade, .hilt, .crossguard],
                                                          property: .simple)
                        for blueprint in WeaponGenerator.shared.generateBlueprints(for: definition) {
                            context.applyBlueprint(blueprint)
                        }
                    }
                Spacer()
                Divider()
                FMPaletteView()
            }
            .frame(width: context.size.width/5)
            Divider()
            FMEditableImageView(bitmap: context.bitmap)
        }
        .onChange(of: activeNode) { activeNode in
            isNewFilePresented = activeNode != nil
        }
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
    
    var body: some View {
        ForEach(node.children, id: \.self) { child in
            VStack {
                FMNameView(node: child, indent: indent + 1, activeNode: $activeNode)
                FMNodeView(node: child, indent: indent + 1, activeNode: $activeNode)
            }
        }
    }
}

struct FMNameView: View {
    @EnvironmentObject var context: FMContext
    let node: FMNode
    let indent: Int
    @Binding var activeNode: FMNode?
    
    var body: some View {
        HStack {
            Text(node.url.lastPathComponent)
            Spacer()
            if node.type == .directory {
                Image(systemName: "plus")
                    .onTapGesture { activeNode = node }
            }
        }
        .frame(height: context.size.height / 32)
        .padding(EdgeInsets(top: 0, leading: CGFloat(16 + 16 * indent),
                             bottom: 0, trailing: 0))
        .background(Rectangle().fill(Color.gray.opacity(0.003)))
        .border(node.type == .directory ? Color.blue : Color.green)
        .onTapGesture {
            if node.type == .file {
                context.setActiveImage(url: node.url)
            }
        }
    }
}
