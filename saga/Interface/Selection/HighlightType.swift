//
//  HighlightType.swift
//  saga
//
//  Created by Christian McCartney on 11/18/21.
//

protocol AdjacencyTileGroupDefinition {
    var name: String { get }
    var adjacencyTextureProvider: AdjacencyTextureProviding { get }
}

protocol AdjacencyTextureProviding {
    var textures: [String] { get }
}

struct HighlightTileGroupDefinition: AdjacencyTileGroupDefinition {
    let name: String
    let adjacencyTextureProvider: AdjacencyTextureProviding
}

enum HighlightType: String, AdjacencyTextureProviding {
    case yellow

    var textures: [String] {
        return ["\(self.rawValue)_highlight_1",
                "\(self.rawValue)_highlight_2",
                "\(self.rawValue)_highlight_3",
                "\(self.rawValue)_highlight_4",
                "\(self.rawValue)_highlight_5",
                "\(self.rawValue)_highlight_6",
                "\(self.rawValue)_highlight_7",
                "\(self.rawValue)_highlight_8",
                "\(self.rawValue)_highlight_9",]
    }
}
