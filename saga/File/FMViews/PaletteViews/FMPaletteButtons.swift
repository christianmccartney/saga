//
//  FMPaletteButtons.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import SwiftUI

struct FMPaletteButtonBarView: View {
    @EnvironmentObject var context: FMContext
    
    var body: some View {
        HStack {
            FMPaletteButtonView(systemName: "arrow.uturn.backward")
                .onTapGesture { context.undo() }
            FMPaletteButtonView(systemName: "arrow.uturn.forward")
                .onTapGesture { context.redo() }
            FMPaletteButtonView(systemName: "square.and.arrow.down")
                .onTapGesture { context.save() }
        }
        .frame(height: context.size.height/12)
    }
}

struct FMPaletteBrushView: View {
    @EnvironmentObject var context: FMContext
    @Binding var selectedX: Int
    @Binding var selectedY: Int
    
    var body: some View {
        HStack {
            Spacer()
            FMPalettePixelView(selectedX: $selectedX, selectedY: $selectedY,
                               x: selectedX, y: selectedY)
                .aspectRatio(1.0, contentMode: .fit)
                .onAppear { context.selectedColor = PixelRGBU8.palette[selectedX][selectedY] }
            Divider()
            Image(systemName: "pencil")
                .resizable()
                .padding(8)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(context.brushType == .paint ? Color.red : Color.blue, lineWidth: 1)
                )
                .onTapGesture { context.brushType = .paint }
            Image(systemName: "drop.fill")
                .resizable()
                .padding(8)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(context.brushType == .fill ? Color.red : Color.blue, lineWidth: 1)
                )
                .onTapGesture { context.brushType = .fill }
            Spacer()
        }
        .frame(height: context.size.height/20)
    }
}

struct FMPaletteButtonView: View {
    @EnvironmentObject var context: FMContext
    let systemName: String
    @State var pressed = false
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(pressed ? Color.red : Color.blue, lineWidth: 1)
            )
//            .onTapGesture {
//                pressed = true
//            }
    }
}
