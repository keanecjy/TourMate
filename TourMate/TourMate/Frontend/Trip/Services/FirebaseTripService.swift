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

    weak var delegate: TripsEventDelegate?

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

        firebaseRepository.listenerDelegate = self
        await firebaseRepository.fetchItemsAndListen(field: "attendeesUserIds", arrayContains: user.uid)
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

    func detachListener() {
        firebaseRepository.detachListener()
    }
}

extension FirebaseTripService: FirebaseEventDelegate {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        guard errorMessage.isEmpty else {
            print(errorMessage)
            return
        }

        // unable to typecast
        guard let adaptedTrips = items as? [FirebaseAdaptedTrip] else {
            print("Unable to convert FirebaseAdaptedData to FirebaseAdaptedTrip")
            return
        }

        let trips = adaptedTrips
            .map({ tripAdapter.toTrip(adaptedTrip: $0) })
            .sorted(by: { $0.startDateTime.date > $1.startDateTime.date })

        // Callback
        await delegate?.update(trips: trips, errorMessage: errorMessage)
    }

}
