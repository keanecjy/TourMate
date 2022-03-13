//
//  PersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

protocol TripPersistenceManager {
    func fetchTrips(userId: String) async -> (trips: [FirebaseAdaptedTrip], errorMessage: String)

    func addTrip(trip: FirebaseAdaptedTrip) async -> (hasAddedTrip: Bool, errorMessage: String)

    func deleteTrip(trip: FirebaseAdaptedTrip) async -> (hasDeletedTrip: Bool, errorMessage: String)

    func updateTrip(trip: FirebaseAdaptedTrip) async -> (hasUpdatedTrip: Bool, errorMessage: String)
}
