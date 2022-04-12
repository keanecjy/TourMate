//
//  MockLocationController.swift
//  TourMate
//
//  Created by Tan Rui Quan on 27/3/22.
//

import Foundation

class MockLocationService: LocationService {
    let locations: [Location] = [
        Location(country: "Singapore",
                 city: "Singapore",
                 addressLineOne: "NUS",
                 addressLineTwo: "National University of Singapore",
                 addressFull: "NUS, National University of Singapore",
                 longitude: 103.776_4, latitude: 1.296_6),
        Location(country: "Singapore",
                 city: "Singapore",
                 addressLineOne: "NTU",
                 addressLineTwo: "Nanyang Technological University",
                 addressFull: "NTU, Nanyang Technological University",
                 longitude: 103.683_1, latitude: 1.348_3),
        Location(country: "Singapore",
                 city: "Singapore",
                 addressLineOne: "SMU",
                 addressLineTwo: "Singapore Management University",
                 addressFull: "SMU, Singapore Management University",
                 longitude: 103.850_2, latitude: 1.296_3),
        Location(country: "Singapore",
                 city: "Singapore",
                 addressLineOne: "SUTD",
                 addressLineTwo: "Singapore University of Technology and Design",
                 addressFull: "SUTD, Singapore University of Technology and Design",
                 longitude: 103.963_3, latitude: 1.341_4),
        Location(country: "Singapore",
                 city: "Singapore",
                 addressLineOne: "SCA",
                 addressLineTwo: "Singapore Changi Airport",
                 addressFull: "SCA, Singapore Changi Airport",
                 longitude: 103.991_5, latitude: 1.364_4)
        ]

    func fetchLocations(query: String) async -> ([Location], String) {
        let suggestedLocations = locations.filter({ $0.addressFull
                .lowercased()
                .contains(query.lowercased()) })
        return (suggestedLocations, "")
    }
}
