//
//  FMImageCollectionView.swift
//  saga
//
//  Created by Christian McCartney on 10/24/21.
//

import SwiftUI

struct FMImageCollectionView: View {
    @EnvironmentObject var context: FMContext
    var bitmap: Bitmap?
    @State var fileNodes: [FileNode]
    @State var nodeType: FMNodeType = .directory
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
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
