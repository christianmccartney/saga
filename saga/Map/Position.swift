//
//  Position.swift
//  saga
//
//  Created by Christian McCartney on 10/22/21.
//

import simd

public struct Position {
    var column: Int
    var row: Int

    public init(_ column: Int, _ row: Int) {
        self.column = column
        self.row = row
    }

    public init(_ vector: vector_int2) {
        self.column = Int(vector.x)
        self.row = Int(vector.y)
    }

    private func distanceSquared(_ pos: Position) -> Float {
        return Float(pos.column - self.column) * Float(pos.column - self.column) + Float(pos.row - self.row) * Float(pos.row - self.row)
    }

    func distance(_ pos: Position) -> Int {
        return Int(sqrt(distanceSquared(pos)))
    }

//    var normalize: Position {
//        let v = simd_float2(Float(column), Float(row))
//        var n = simd.normalize(v)
//        return Position(Int(n.x), Int(n.y))
//    }
    
//    func floor(_ scale: Int) -> Position {
//        return Position(column > 0 ? min(column, scale) : max(column, scale),
//                        row > 0 ? min(row, scale) : max(row, scale))
//    }
}

extension Position: Equatable {
    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
}

extension Position: Hashable {}

extension Position {
    static func - (left: Position, right: Position) -> Position {
        return Position(left.column - right.column, left.row - right.row)
    }

    static func + (left: Position, right: Position) -> Position {
        return Position(left.column + right.column, left.row + right.row)
    }
}
