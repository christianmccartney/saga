//
//  FMPaletteColors.swift
//  saga
//
//  Created by Christian McCartney on 10/25/21.
//

import SwiftUI

struct FMPaletteColorsView: View {
    @Binding var selectedX: Int
    @Binding var selectedY: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<PixelRGBU8.palette.count, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<PixelRGBU8.palette[0].count, id: \.self) { x in
                        FMPalettePixelView(selectedX: $selectedX, selectedY: $selectedY,
                                           x: x, y: y)
                    }
                }
            }
        }
    }
}

struct FMPalettePixelView: View {
    @EnvironmentObject var context: FMContext
    @Binding var selectedX: Int
    @Binding var selectedY: Int
    let x: Int
    let y: Int
    
    var body: some View {
        Rectangle()
            .fill(Color(PixelRGBU8.palette[y][x].uiColor))
            .onTapGesture {
                selectedX = x
                selectedY = y
                context.selectedColor = PixelRGBU8.palette[y][x]
            }
    }
}
