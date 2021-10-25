//
//  FMFileViews.swift
//  saga
//
//  Created by Christian McCartney on 10/23/21.
//

import SwiftUI

struct FileStructureView: View {
    @EnvironmentObject var context: FMContext
    var body: some View {
        HStack {
            VStack {
                VStack {
                    FMNameView(node: FM.shared.baseNode, indent: 0)
                        .border(.red)
                    FMNodeView(node: FM.shared.baseNode, indent: 0)
                    Spacer()
                }
                .frame(height: context.size.height/2)
                Spacer()
                Divider()
                FMPaletteView()
//                    .aspectRatio(1.0, contentMode: .fit)
            }
            .frame(width: context.size.width/5)
            Divider()
            FMEditableImageView(bitmap: context.bitmap)
//                    .aspectRatio(1.0, contentMode: .fit)
        }
    }
}

struct FMNodeView: View {
    @EnvironmentObject var context: FMContext
    let node: FMNode
    let indent: Int
    
    var body: some View {
        ForEach(node.children, id: \.self) { child in
            VStack {
                FMNameView(node: child, indent: indent + 1)
                FMNodeView(node: child, indent: indent + 1)
            }
        }
    }
}

struct FMNameView: View {
    @EnvironmentObject var context: FMContext
    let node: FMNode
    let indent: Int
    
    var body: some View {
        HStack {
            Text(node.url.lastPathComponent)
            Spacer()
            if node.type == .directory {
                Image(systemName: "plus")
                    .onTapGesture {
                        if let _ = FM.shared.addFile(
                            of: .png,
                            to: node.url.appendingPathComponent("img.png"),
                            node: node) {
                            context.setActiveImage(url: node.url)
                        }
                    }
            }
        }
        .frame(height: context.size.height / 32)
        .padding(EdgeInsets(top: 0, leading: CGFloat(16 + 16 * indent),
                             bottom: 0, trailing: 0))
        .background(Rectangle().fill(Color.gray.opacity(0.003)))
        .border(node.type == .directory ? .blue : .green)
        .onTapGesture {
            if node.type == .file {
                context.setActiveImage(url: node.url)
            }
        }
    }
}
