//
//  MockPlaceService.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/4/22.
//

import Foundation

class MockPlaceService: PlaceService {
    let nearbyPlaces: [NearbyPlace] = [
        NearbyPlace(name: "Starbucks",
                    location: Location(addressFull: "592 Bailey River", longitude: 11, latitude: 11),
                    rating: 4.0),
        NearbyPlace(name: "Coffee Bean",
                    location: Location(addressFull: "55430 Balistreri Plaza", longitude: 22, latitude: 22),
                    rating: 3.2),
        NearbyPlace(name: "Red Lobster",
                    location: Location(addressFull: "3707 Oren Village", longitude: 33, latitude: 33),
                    rating: 5.0)
    ]

    func fetchTourismPlaces(near: Location) async -> ([NearbyPlace], String) {
        (nearbyPlaces, "")
    }
}
