//
//  RoutingResult.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import Foundation

enum TravelMode {
    case drive
    case motorcycle
    // transit is public transport
    case transit
    case walk
    case bicycle
}

struct RoutingResult {
    let mode: TravelMode
    // Distance in meters
    let distance: Int
    // Time in seconds
    let time: Double
}
