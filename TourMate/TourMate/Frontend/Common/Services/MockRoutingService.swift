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
        RoutingResult(
            mode: .drive,
            distance: Measurement(value: 13_000, unit: UnitLength.meters),
            time: Measurement(value: 900, unit: UnitDuration.seconds)),
        RoutingResult(
            mode: .transit,
            distance: Measurement(value: 14_000, unit: UnitLength.meters),
            time: Measurement(value: 3_480, unit: UnitDuration.seconds)),
        RoutingResult(
            mode: .walk,
            distance: Measurement(value: 16_000, unit: UnitLength.meters),
            time: Measurement(value: 12_360, unit: UnitDuration.seconds)),
        RoutingResult(
            mode: .bicycle,
            distance: Measurement(value: 14_000, unit: UnitLength.meters),
            time: Measurement(value: 2_760, unit: UnitDuration.seconds))
    ]

    func fetchTransportationOptions(from: Location, to: Location) async -> ([RoutingResult], String) {
        (results, "")
    }
}
