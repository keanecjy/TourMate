//
//  MockLocationController.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

class MockLocationService: LocationService {
    let locations: [Location] = [
        Location(addressLineOne: "SCA",
                 addressLineTwo: "Singapore Changi Airport",
                 addressFull: "SCA, Singapore Changi Airport",
                 longitude: 1.2, latitude: 3.4),
        Location(addressLineOne: "NUS",
                 addressLineTwo: "National University of Singapore",
                 addressFull: "NUS, National University of Singapore",
                 longitude: 4.5, latitude: 6.7),
        Location(addressLineOne: "NTU",
                 addressLineTwo: "Nanyang Technological University",
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
