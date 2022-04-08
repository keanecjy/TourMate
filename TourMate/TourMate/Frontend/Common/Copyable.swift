//
//  Copyable.swift
//  TourMate
//
//  Created by Keane Chan on 9/4/22.
//

protocol Copyable {
    init()
}

extension Copyable {
    func copy() -> Self {
        Self()
    }
}
