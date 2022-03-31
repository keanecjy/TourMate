//
//  MockLocationController.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

class MockLocationService: LocationService {
    let locations: [Location] = [
        Location(addressLineOne: "NUS",
                 addressLineTwo: "National University of Singapore",
                 addressFull: "NUS, National University of Singapore",
                 longitude: 1.2966, latitude: 103.7764),
        Location(addressLineOne: "NTU",
                 addressLineTwo: "Nanyang Technological University",
                 addressFull: "NTU, Nanyang Technological University",
                 longitude: 1.3483, latitude: 103.6831),
        Location(addressLineOne: "SMU",
                 addressLineTwo: "Singapore Management University",
                 addressFull: "SMU, Singapore Management University",
                 longitude: 1.2963, latitude: 103.8502),
        Location(addressLineOne: "SUTD",
                 addressLineTwo: "Singapore University of Technology and Design",
                 addressFull: "SUTD, Singapore University of Technology and Design",
                 longitude: 1.3414, latitude: 103.9633),
        Location(addressLineOne: "SCA",
                 addressLineTwo: "Singapore Changi Airport",
                 addressFull: "SCA, Singapore Changi Airport",
                 longitude: 1.3644, latitude: 103.9915)
    ]

    func fetchLocations(query: String) async -> ([Location], String) {
        let suggestedLocations = locations.filter({ $0.addressFull
                .lowercased()
                .contains(query.lowercased()) })
        return (suggestedLocations, "")
    }
}
