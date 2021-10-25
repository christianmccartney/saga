//
//  FMPaletteViews.swift
//  saga
//
//  Created by Christian McCartney on 10/24/21.
//

import SwiftUI

private let lRed = PixelRGBU8(214, 98, 58)
private let red = PixelRGBU8(236, 79, 71)
private let dRed = PixelRGBU8(208, 56, 48)
private let vdRed = PixelRGBU8(131, 35, 30)

private let lGreen = PixelRGBU8(244, 225, 125)
private let green = PixelRGBU8(172, 203, 75)
private let dGreen = PixelRGBU8(86, 134, 47)
private let vdGreen = PixelRGBU8(52, 71, 77)

private let blue = PixelRGBU8(82, 161, 236)
private let dBlue = PixelRGBU8(33, 87, 128)
private let vdBlue = PixelRGBU8(29, 38, 49)

private let pink = PixelRGBU8(230, 108, 241)
private let purple = PixelRGBU8(181, 64, 191)
private let dPurple = PixelRGBU8(33, 87, 128)

private let lYellow = PixelRGBU8(244, 225, 125)
private let yellow = PixelRGBU8(222, 141, 69)
private let dYellow = PixelRGBU8(155, 102, 49)
private let vdYellow = PixelRGBU8(46, 37, 31)

private let white = PixelRGBU8(255, 255, 255)
private let llGray = PixelRGBU8(243, 243, 243)
private let lGray = PixelRGBU8(212, 212, 212)
private let gray = PixelRGBU8(157, 157, 157)
private let dGray = PixelRGBU8(103, 103, 103)
private let vdGray = PixelRGBU8(61, 61, 61)
private let lBlack = PixelRGBU8(19, 38, 49)
private let black = PixelRGBU8(20, 23, 28)
private let dBlack = PixelRGBU8(20, 20, 20)

let palette: [[PixelRGBU8]] = [
    [lRed,      red,    dRed,       vdRed,      white],
    [lYellow,   yellow, dYellow,    vdYellow,   white],
    [lGreen,    green,  dGreen,     vdGreen,    white],
    [lGray,     blue,   vdBlue,     dBlue,      white],
    [lGray,     pink,   purple,     dPurple,    white],
    [llGray,    lGray,  gray,       vdGray,     white],
    [dGray,     lBlack, black,      dBlack,     white],]

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
