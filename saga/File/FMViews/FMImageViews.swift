//
//  FMImageViews.swift
//  saga
//
//  Created by Christian McCartney on 10/24/21.
//

import SwiftUI

struct FMEditableImageView: View {
    @EnvironmentObject var context: FMContext
    var bitmap: Bitmap?
    @State var cellsDragged = Set<Position>()
    @State var cellsSet = Set<Position>()
    @State var fileNodes: [FileNode]
    @State var nodeType: FMNodeType = .directory
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
//        if STANDARD_WEAPON_WIDTH > 64 {
        ZStack {
            if nodeType == .directory {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(fileNodes, id: \.self) { fileNode in
                            FMImageView(image: fileNode.image, uiImage: fileNode.image.image)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
            }
            if nodeType == .file {
                ForEach(fileNodes, id: \.self) { fileNode in
                    FMImageView(image: fileNode.image, uiImage: fileNode.image.image)
                }
            }
        }.onReceive(context.$activeNode) { activeNode in
            fileNodes = activeNode?.fileNodes ?? []
            if let fileNode = activeNode as? FileNode {
                fileNodes = [fileNode]
            }
        }
//        .onReceive(context.$activeNode) { activeNode in
//            self.images = activeNode?.images ?? []
//        }
//        .onReceive(context.activeNode?.$images ?? ) { images in
//            self.images = images
//        }
//        } else {
//            GeometryReader { geometry in
//                VStack(spacing: 0) {
//                    ForEach(0..<(bitmap?.height ?? 0), id: \.self) { y in
//                        FMEditableImageRowView(
//                            width: bitmap?.width ?? 0,
//                            y: y,
//                            cellsDragged: $cellsDragged,
//                            cellsSet: $cellsSet)
//                    }
//                }
//                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                            .onChanged({ value in
//                    guard let bitmap = bitmap else { return }
//                    let x = value.location.x / (geometry.size.width / CGFloat(bitmap.width))
//                    let y = value.location.y / (geometry.size.height / CGFloat(bitmap.height))
//                    cellsDragged.insert(Position(Int(x), Int(y)))
//                })
//                            .onEnded({ _ in
//                    cellsDragged = Set<Position>()
//                    cellsSet = Set<Position>()
//                })
//                )
//            }
//        }
    }
}

struct FMImageView: View {
    var image: FMImage
    @State var uiImage: UIImage
    
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .frame(width: CGFloat(STANDARD_WEAPON_WIDTH) * 2,
                   height: CGFloat(STANDARD_WEAPON_HEIGHT) * 2)
            .onReceive(image.$image) { image in
                uiImage = image
            }
    }
}

//struct FMEditableImageRowView: View {
//    @EnvironmentObject var context: FMContext
//    let width: Int
//    let y: Int
//    @State var bitmap: Bitmap?
//    @Binding var cellsDragged: Set<Position>
//    @Binding var cellsSet: Set<Position>
//
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(0..<width, id: \.self) { x in
//                FMEditableImagePixelView(
//                    x: x,
//                    y: y,
//                    color: context.bitmap?.getPixel(x: x, y: y).uiColor ?? .clear,
//                    cellsDragged: $cellsDragged,
//                    cellsSet: $cellsSet)
//            }
//        }
//        .onReceive(context.$bitmap) { bitmap in
//            self.bitmap = bitmap
//        }
//    }
//}

//struct FMEditableImagePixelView: View {
//    @EnvironmentObject var context: FMContext
//    let x: Int
//    let y: Int
//    let color: UIColor
//    @Binding var cellsDragged: Set<Position>
//    @Binding var cellsSet: Set<Position>
//
//    var body: some View {
//        Rectangle()
//            .fill(Color(color))
//            .onChange(of: cellsDragged) { cellsDragged in
//                if cellsDragged.contains(where: { $0.column == x && $0.row == y }),
//                   !cellsSet.contains(where: { $0.column == x && $0.row == y }) {
//                    if let color = context.selectedColor {
//                        context.applyColor(x: x, y: y, color: color)
//                    }
//                    cellsSet.insert(Position(x, y))
//                }
//            }
//            .onTapGesture {
//                if let color = context.selectedColor {
//                    context.applyColor(x: x, y: y, color: color)
//                }
//            }
//    }
//}
