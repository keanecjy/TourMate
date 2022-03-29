//
//  MockLocationController.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

class MockLocationService: LocationService {
    let locations: [Location] = [
        Location(addressShort: "SCA",
                 addressLong: "Singapore Changi Airport",
                 addressFull: "SCA, Singapore Changi Airport",
                 longitude: 1.2, latitude: 3.4),
        Location(addressShort: "NUS",
                 addressLong: "National University of Singapore",
                 addressFull: "NUS, National University of Singapore",
                 longitude: 4.5, latitude: 6.7),
        Location(addressShort: "NTU",
                 addressLong: "Nanyang Technological University",
                 addressFull: "NTU, Nanyang Technological University",
                 longitude: 1.9, latitude: 4.5)
    ]

    func fetchLocations(query: String) async -> ([Location], String) {
        let suggestedLocations = locations.filter({ $0.addressFull
                .lowercased()
                .contains(query.lowercased()) })
        return (suggestedLocations, "")
    }
}
