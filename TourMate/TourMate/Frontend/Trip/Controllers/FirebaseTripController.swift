//
//  FirebaseTripController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseAuth

struct FirebaseTripController: TripController {
    private let firebasePersistenceManager = FirebasePersistenceManager(
        collectionId: FirebaseConfig.tripCollectionId)

    private let tripAdapter = TripAdapter()

    func addTrip(trip: Trip) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: trip.id, item:
                                                    tripAdapter.toAdaptedTrip(trip: trip) )
    }

    func fetchTrips() async -> ([Trip], String) {
        guard let user = Auth.auth().currentUser else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        let (adaptedTrips, errorMessage) = await firebasePersistenceManager
            .fetchItems(field: "attendeesUserIds", arrayContains: user.uid)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        // unable to typecast
        guard let adaptedTrips = adaptedTrips as? [FirebaseAdaptedTrip] else {
             return ([], "Unable to convert FirebaseAdaptedData to FirebaseAdaptedTrip")
        }

        let trips = adaptedTrips.map({ tripAdapter.toTrip(adaptedTrip: $0) })
            .sorted(by: { $0.startDate > $1.startDate })
        return (trips, "")
    }

    func fetchTrip(withTripId tripId: String) async -> (Trip?, String) {
        guard let user = Auth.auth().currentUser else {
            return (nil, Constants.messageUserNotLoggedIn)
        }

        let (adaptedTrip, errorMessage) = await firebasePersistenceManager.fetchItem(id: tripId)
        guard errorMessage.isEmpty else {
           return (nil, errorMessage)
        }
        guard let adaptedTrip = adaptedTrip as? FirebaseAdaptedTrip else {
            return (nil, "[FirebaseTripController] Error converting FirebaseAdaptedData into FirebaseAdaptedTrip")
        }
        guard adaptedTrip.attendeesUserIds.contains(user.uid) else {
            return (nil, "[FirebaseTripController] Error user \(user.uid) is not an attendee of trip \(tripId)")
        }

        let trip = tripAdapter.toTrip(adaptedTrip: adaptedTrip)
        return (trip, errorMessage)
    }

    func deleteTrip(trip: Trip) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: trip.id)
    }

    func updateTrip(trip: Trip) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: trip.id,
                                                    item: tripAdapter.toAdaptedTrip(trip: trip))
    }
}
