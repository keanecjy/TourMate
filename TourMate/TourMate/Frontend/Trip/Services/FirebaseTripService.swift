//
//  FirebaseTripService.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseAuth

class FirebaseTripService: TripService {
    private var firebaseRepository = FirebaseRepository(collectionId: FirebaseConfig.tripCollectionId)

    private let tripAdapter = TripAdapter()

    weak var tripEventDelegate: TripEventDelegate?

    func addTrip(trip: Trip) async -> (Bool, String) {
        print("[FirebaseTripService] Adding trip")

        return await firebaseRepository.addItem(id: trip.id, item:
                                                    tripAdapter.toAdaptedTrip(trip: trip) )
    }

    func fetchTripsAndListen() async {
        guard let user = Auth.auth().currentUser else {
            print(Constants.messageUserNotLoggedIn)
            return
        }

        print("[FirebaseTripService] Fetching and listening to trips")

        firebaseRepository.eventDelegate = self
        await firebaseRepository.fetchItemsAndListen(field: "attendeesUserIds", arrayContains: user.uid)
    }

    func fetchTripAndListen(withTripId tripId: String) async {
        print("[FirebaseTripService] Fetching and listening to single trip \(tripId)")

        firebaseRepository.eventDelegate = self
        await firebaseRepository.fetchItemAndListen(id: tripId)
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

    func detachListener() {
        firebaseRepository.detachListener()
    }
}

// MARK: - FirebaseEventDelegate
extension FirebaseTripService: FirebaseEventDelegate {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        print("[FirebaseTripService] Updating trips")

        guard Auth.auth().currentUser != nil else {
            await tripEventDelegate?.update(trips: [], errorMessage: Constants.messageUserNotLoggedIn)
            return
        }

        guard errorMessage.isEmpty else {
            await tripEventDelegate?.update(trips: [], errorMessage: errorMessage)
            return
        }

        guard let adaptedTrips = items as? [FirebaseAdaptedTrip] else {
            await tripEventDelegate?.update(trips: [], errorMessage: Constants.errorTripConversion)
            return
        }

        let trips = adaptedTrips
            .map({ tripAdapter.toTrip(adaptedTrip: $0) })
            .sorted(by: { $0.startDateTime.date > $1.startDateTime.date })

        await tripEventDelegate?.update(trips: trips, errorMessage: errorMessage)
    }

    func update(item: FirebaseAdaptedData?, errorMessage: String) async {
        print("[FirebaseTripService] Updating single trip")

        guard let user = Auth.auth().currentUser else {
            await tripEventDelegate?.update(trip: nil, errorMessage: Constants.messageUserNotLoggedIn)
            return
        }

        guard errorMessage.isEmpty else {
            await tripEventDelegate?.update(trip: nil, errorMessage: errorMessage)
            return
        }

        guard let adaptedTrip = item as? FirebaseAdaptedTrip else {
            await tripEventDelegate?.update(trip: nil, errorMessage: Constants.errorTripConversion)
            return
        }

        guard adaptedTrip.attendeesUserIds.contains(user.uid) else {
            let errorMsg = "[FirebaseTripService] Error user \(user.uid) is not an attendee of trip \(adaptedTrip.id)"
            await tripEventDelegate?.update(trip: nil, errorMessage: errorMsg)
            return
        }

        let trip = tripAdapter.toTrip(adaptedTrip: adaptedTrip)
        await tripEventDelegate?.update(trip: trip, errorMessage: errorMessage)
    }

}
