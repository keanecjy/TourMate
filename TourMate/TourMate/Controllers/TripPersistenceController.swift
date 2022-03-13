//
//  TripPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import FirebaseAuth

struct TripPersistenceController {
    let firebasePersistenceManager = FirebasePersistenceManager<FirebaseAdaptedTrip>(
        collectionId: FirebaseConfig.tripCollectionId)

    func addTrip(trip: NewTrip) async -> (Bool, String) {
        guard Auth.auth().currentUser != nil else {
            return (false, "User is not logged in")
        }

        return await firebasePersistenceManager.addItem(id: trip.id, item: trip.toData())
    }

    func fetchTrip() async -> ([NewTrip], String) {
        guard let user = Auth.auth().currentUser,
              let email = user.email
        else {
            return ([], "User is not logged in")
        }

        let (adaptedTrips, errorMessage) = await firebasePersistenceManager.fetchItems(field: "userIds", id: email)
        let trips = adaptedTrips.map({ $0.toItem() })
        return (trips, errorMessage)
    }

    func deleteTrip(trip: NewTrip) async -> (Bool, String) {
        guard Auth.auth().currentUser != nil else {
            return (false, "User is not logged in")
        }

        return await firebasePersistenceManager.deleteItem(id: trip.id)
    }

    func updateTrip(trip: NewTrip) async -> (Bool, String) {
        guard Auth.auth().currentUser != nil else {
            return (false, "User is not logged in")
        }

        return await firebasePersistenceManager.updateItem(id: trip.id, item: trip.toData())
    }
}

extension NewTrip {
    fileprivate func toData() -> FirebaseAdaptedTrip {
        FirebaseAdaptedTrip(id: id, userIds: userIds, userNames: userNames, name: name,
                            imageUrl: imageUrl, creationDate: creationDate, modificationDate: modificationDate)
    }
}

extension FirebaseAdaptedTrip {
    fileprivate func toItem() -> NewTrip {
        NewTrip(id: id, userIds: userIds, userNames: userNames, name: name,
             imageUrl: imageUrl, creationDate: creationDate, modificationDate: modificationDate)
    }
}
