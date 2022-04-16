//
//  MockRoutingService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 16/4/22.
//

import Foundation

class MockRoutingService: RoutingService {
    // Results for from NUS to NTU
    let results: [RoutingResult] = [
        RoutingResult(mode: .drive, distance: 13_000, time: 900),
        RoutingResult(mode: .motorcycle, distance: 13_000, time: 900),
        RoutingResult(mode: .transit, distance: 14_000, time: 3_480),
        RoutingResult(mode: .walk, distance: 16_000, time: 12_360),
        RoutingResult(mode: .bicycle, distance: 14_000, time: 2_760)
    ]

    func fetchTransportationOptions(from: Location, to: Location) async -> ([RoutingResult], String) {
        (results, "")
    }
}
