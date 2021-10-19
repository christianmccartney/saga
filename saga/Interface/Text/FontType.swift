//
//  FontType.swift
//  Saga
//
//  Created by Christian McCartney on 5/26/20.
//  Copyright © 2020 Christian McCartney. All rights reserved.
//

import Foundation

public enum FontType: Int, CaseIterable {
    case shadowed = 4
    case light = 2
    case dark = 0
}

extension String {
    static let supportedCharacters: [Character] = [
        //" ",
        "a",
        "b",
        "c",
        "d",
        "e",
        "f",
        "g",
        "h",
        "i",
        "j",
        "k",
        "l",
        "m",
        "n",
        "o",
        "p",
        "q",
        "r",
        "s",
        "t",
        "u",
        "v",
        "w",
        "x",
        "y",
        "z",
        "0",
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "!",
        "@",
        "#",
        "$",
        "%",
        "^",
        "&",
        "*",
        "(",
        ")",
        "-",
        "+",
        "=",
        ":",
        ";",
        ",",
        "\"",
        "<",
        ">",
        ".",
        "?",
        "/",
        "\\",
        "[",
        "]",
        "_",
        "|",
        "☐",
        "'",
        "☒",
        "█",
        "⊙",
        "‴",
        "░",
        "→",
        "←",
    ]
}
