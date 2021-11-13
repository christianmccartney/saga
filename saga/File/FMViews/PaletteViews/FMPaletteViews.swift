//
//  FMPaletteViews.swift
//  saga
//
//  Created by Christian McCartney on 10/24/21.
//

import SwiftUI

extension PixelRGBU8 {
    static let lRed = PixelRGBU8(214, 98, 58)
    static let red = PixelRGBU8(236, 79, 71)
    static let dRed = PixelRGBU8(208, 56, 48)
    static let vdRed = PixelRGBU8(131, 35, 30)

    static let lGreen = PixelRGBU8(244, 225, 125)
    static let green = PixelRGBU8(172, 203, 75)
    static let dGreen = PixelRGBU8(86, 134, 47)
    static let vdGreen = PixelRGBU8(52, 71, 77)

    static let blue = PixelRGBU8(82, 161, 236)
    static let dBlue = PixelRGBU8(33, 87, 128)
    static let vdBlue = PixelRGBU8(29, 38, 49)

    static let pink = PixelRGBU8(230, 108, 241)
    static let purple = PixelRGBU8(181, 64, 191)
    static let dPurple = PixelRGBU8(33, 87, 128)

    static let lYellow = PixelRGBU8(244, 225, 125)
    static let yellow = PixelRGBU8(222, 141, 69)
    static let dYellow = PixelRGBU8(155, 102, 49)
    static let vdYellow = PixelRGBU8(46, 37, 31)

    static let white = PixelRGBU8(255, 255, 255)
    static let llGray = PixelRGBU8(243, 243, 243)
    static let lGray = PixelRGBU8(212, 212, 212)
    static let gray = PixelRGBU8(157, 157, 157)
    static let dGray = PixelRGBU8(103, 103, 103)
    static let vdGray = PixelRGBU8(61, 61, 61)
    static let lBlack = PixelRGBU8(19, 38, 49)
    static let black = PixelRGBU8(20, 23, 28)
    static let dBlack = PixelRGBU8(20, 20, 20)
    
    static let clear = PixelRGBU8(0, 0, 0, 0)
    
    static let palette: [[PixelRGBU8]] = [
        [lRed,      red,    dRed,       vdRed,      white],
        [lYellow,   yellow, dYellow,    vdYellow,   white],
        [lGreen,    green,  dGreen,     vdGreen,    white],
        [lGray,     blue,   vdBlue,     dBlue,      white],
        [lGray,     pink,   purple,     dPurple,    white],
        [llGray,    lGray,  gray,       vdGray,     white],
        [dGray,     lBlack, black,      dBlack,     white],]
}


struct FMPaletteView: View {
    @EnvironmentObject var context: FMContext
    @State var selectedX: Int = 0
    @State var selectedY: Int = 0
    
    var body: some View {
        VStack {
            VStack {
                FMPaletteButtonBarView()
                Divider()
                FMPaletteBrushView(selectedX: $selectedX, selectedY: $selectedY)
            }
            Divider()
            FMPaletteColorsView(selectedX: $selectedX, selectedY: $selectedY)
                    .aspectRatio(1.0, contentMode: .fit)
        }
    }
}
