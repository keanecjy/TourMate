//
//  NearbyPlace.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import Foundation

struct NearbyPlace {
    let name: String
    let location: Location
    let rating: Double
}

extension NearbyPlace: Identifiable {
    var id: String {
        location.id
    }
}

extension NearbyPlace: Hashable {
    static func == (lhs: NearbyPlace, rhs: NearbyPlace) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
