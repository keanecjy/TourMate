//
//  FirebaseTripController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseAuth

struct FirebaseTripController: TripController {
    let firebasePersistenceManager = FirebasePersistenceManager(
        collectionId: FirebaseConfig.tripCollectionId)

    func addTrip(trip: Trip) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: trip.id, item: trip.toData())
    }

    func fetchTrips() async -> ([Trip], String) {
        guard let user = Auth.auth().currentUser else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        let (adaptedTrips, errorMessage): ([FirebaseAdaptedTrip], String) = await firebasePersistenceManager
            .fetchItems(field: "attendeesUserIds", arrayContains: user.uid)

        let trips = adaptedTrips.map({ $0.toItem() })
            .sorted(by: { $0.startDate > $1.startDate })
        return (trips, errorMessage)
    }
    
    func fetchTrip(withTripId tripId: String) async -> (Trip?, String) {
        guard (Auth.auth().currentUser != nil) else {
            return (nil, Constants.messageUserNotLoggedIn)
        }
        
        let (adaptedTrip, errorMessage): (FirebaseAdaptedTrip?, String) = await firebasePersistenceManager.fetchItem(id: tripId)
        guard let adaptedTrip = adaptedTrip else {
            return (nil, errorMessage)
        }

        let trip = adaptedTrip.toItem()
        return (trip, errorMessage)
    }

    func deleteTrip(trip: Trip) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: trip.id)
    }

    func updateTrip(trip: Trip) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: trip.id, item: trip.toData())
    }
}

extension Trip {
    fileprivate func toData() -> FirebaseAdaptedTrip {
        FirebaseAdaptedTrip(id: id, name: name, startDate: startDate, endDate: endDate, timeZone: timeZone,
                            imageUrl: imageUrl, attendeesUserIds: attendeesUserIds, invitedUserIds: invitedUserIds,
                            creationDate: creationDate, modificationDate: modificationDate)
    }
}

extension FirebaseAdaptedTrip {
    fileprivate func toItem() -> Trip {
        Trip(id: id, name: name, startDate: startDate, endDate: endDate, timeZone: timeZone,
             imageUrl: imageUrl, attendeesUserIds: attendeesUserIds, invitedUserIds: invitedUserIds,
             creationDate: creationDate, modificationDate: modificationDate)
    }
}
