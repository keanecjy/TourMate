//
//  FirebaseTripService.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseAuth
import Foundation
import CloudKit
import SwiftUI

struct FirebaseTripService: TripService {
    private let firebaseRepository = FirebaseRepository(
        collectionId: FirebaseConfig.tripCollectionId)

    private let tripAdapter = TripAdapter()

    func addTrip(trip: Trip) async -> (Bool, String) {
        print("[FirebaseTripService] Adding trip")

        return await firebaseRepository.addItem(id: trip.id, item:
                                            tripAdapter.toAdaptedTrip(trip: trip) )
    }

    func fetchTrips() async -> ([Trip], String) {
        guard let user = Auth.auth().currentUser else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        print("[FirebaseTripService] Fetching trips")
        let (adaptedTrips, errorMessage) = await firebaseRepository
            .fetchItems(field: "attendeesUserIds", arrayContains: user.uid)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        // unable to typecast
        guard let adaptedTrips = adaptedTrips as? [FirebaseAdaptedTrip] else {
            return ([], "Unable to convert FirebaseAdaptedData to FirebaseAdaptedTrip")
        }

        let trips = adaptedTrips
            .map({ tripAdapter.toTrip(adaptedTrip: $0) })
            .sorted(by: { $0.startDateTime.date > $1.startDateTime.date })
        return (trips, "")
    }

    func fetchTrip(withTripId tripId: String) async -> (Trip?, String) {
        guard let user = Auth.auth().currentUser else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        print("[FirebaseTripService] Fetching single trip")
        let (adaptedTrip, errorMessage) = await firebaseRepository.fetchItem(id: tripId)
        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }
        guard let adaptedTrip = adaptedTrip as? FirebaseAdaptedTrip else {
            return (nil, "[FirebaseTripService] Error converting FirebaseAdaptedData into FirebaseAdaptedTrip")
        }
        guard adaptedTrip.attendeesUserIds.contains(user.uid) else {
            return (nil, "[FirebaseTripService] Error user \(user.uid) is not an attendee of trip \(tripId)")
        }

        let trip = tripAdapter.toTrip(adaptedTrip: adaptedTrip)
        return (trip, errorMessage)
    }

    func deleteTrip(trip: Trip) async -> (Bool, String) {
        print("[FirebaseTripService] Deleting trip")

        return await firebaseRepository.deleteItem(id: trip.id)
    }

    func updateTrip(trip: Trip) async -> (Bool, String) {
        print("[FirebaseTripService] Updating trip")

        return await firebaseRepository.updateItem(id: trip.id,
                                                   item: tripAdapter.toAdaptedTrip(trip: trip))
    }
}
