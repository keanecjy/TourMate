//
//  TripController.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation

protocol TripController {
    func fetchTrips() async -> ([Trip], String)

    mutating func addTrip(trip: Trip) async -> (Bool, String)

    mutating func deleteTrip(trip: Trip) async -> (Bool, String)

    mutating func updateTrip(trip: Trip) async -> (Bool, String)
}
