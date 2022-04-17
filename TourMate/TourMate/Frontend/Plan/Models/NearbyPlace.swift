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
    var id: UUID {
        UUID()
    }
}
