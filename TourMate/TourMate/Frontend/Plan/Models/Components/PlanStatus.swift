//
//  PlanStatus.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

enum PlanStatus: String, CustomStringConvertible {
    case proposed
    case confirmed

    var description: String {
        self.rawValue.capitalized
    }
}
