//
//  HighlightType.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

public protocol AdjacencyTileGroupDefinition {
    var name: String { get }
    var adjacencyTextureProvider: AdjacencyTextureProviding { get }
}

public protocol AdjacencyTextureProviding {
    var textures: [String] { get }
}

struct HighlightTileGroupDefinition: AdjacencyTileGroupDefinition {
    let name: String
    let adjacencyTextureProvider: AdjacencyTextureProviding
}

enum HighlightType: String, AdjacencyTextureProviding {
    case yellow = "yellow"
    case innerYellow = "inner_yellow"
    case blue = "blue"

    var textures: [String] {
        return ["\(self.rawValue)_highlight_1",
                "\(self.rawValue)_highlight_2",
                "\(self.rawValue)_highlight_3",
                "\(self.rawValue)_highlight_4",
                "\(self.rawValue)_highlight_5",
                "\(self.rawValue)_highlight_6",
                "\(self.rawValue)_highlight_7",
                "\(self.rawValue)_highlight_8",
                "\(self.rawValue)_highlight_9",
                "\(self.rawValue)_highlight_10",
                "\(self.rawValue)_highlight_11",
                "\(self.rawValue)_highlight_12",
                "\(self.rawValue)_highlight_13",
                "\(self.rawValue)_highlight_14",
                "\(self.rawValue)_highlight_15",
                "\(self.rawValue)_highlight_16",
                "\(self.rawValue)_highlight_17",
                "\(self.rawValue)_highlight_18",]
    }
}
