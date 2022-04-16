//
//  RoutingResult.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import Foundation

struct RoutingResult {
    let mode: TravelMode
    // Distance in meters
    let distance: Measurement<UnitLength>
    // Time in seconds
    let time: Measurement<UnitDuration>
}

extension RoutingResult: Identifiable {
    var id: UUID {
        UUID()
    }
}
