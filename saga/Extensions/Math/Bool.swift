//
//  Bool.swift
//  saga
//
//  Created by Christian McCartney on 11/23/21.
//

extension Bool {
    static func + (_ lhs: Bool, _ rhs: Bool) -> Int {
        return (lhs ? 1 : 0) + (rhs ? 1 : 0)
    }
}
