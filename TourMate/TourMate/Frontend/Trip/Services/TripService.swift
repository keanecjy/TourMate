//
//  TripService.swift
//  TourMate
//
//  Created by Rayner Lim on 17/3/22.
//

import Foundation

protocol TripService {
    func fetchTripsAndListen() async

    func fetchTripAndListen(withTripId tripId: String) async

    func addTrip(trip: Trip) async -> (Bool, String)

    func deleteTrip(trip: Trip) async -> (Bool, String)

    func updateTrip(trip: Trip) async -> (Bool, String)

    var tripEventDelegate: TripEventDelegate? { get set }

    func detachListener()
}
