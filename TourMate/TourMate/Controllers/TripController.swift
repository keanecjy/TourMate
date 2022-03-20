//
//  TripController.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation

protocol TripController {
    func fetchTrips() async -> ([Trip], String)
    
    func fetchTrip(withTripId tripId: String) async -> (Trip?, String)

    func addTrip(trip: Trip) async -> (Bool, String)

    func deleteTrip(trip: Trip) async -> (Bool, String)

    func updateTrip(trip: Trip) async -> (Bool, String)
}
