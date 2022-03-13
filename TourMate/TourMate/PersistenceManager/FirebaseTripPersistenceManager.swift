//
//  FirebasePersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Firebase
import Foundation

struct FirebaseTripPersistenceManager: TripPersistenceManager {
    private let db = Firestore.firestore()

    @MainActor
    func fetchTrips(userId: String) async -> (trips: [FirebaseAdaptedTrip], errorMessage: String) {
        var trips: [FirebaseAdaptedTrip] = []
        var errorMessage = ""

        do {
            let query = db.collection(FirebaseConfig.tripCollectionId).whereField("attendees", arrayContains: userId)
            let documents = try await query.getDocuments().documents
            trips = documents.compactMap({ try? $0.data(as: FirebaseAdaptedTrip.self) })
        } catch {
            errorMessage = "[FirebaseTripPersistenceManager] Error getting trip: \(error)"
        }

        return (trips, errorMessage)
    }

    @MainActor
    func addTrip(trip: FirebaseAdaptedTrip) async -> (hasAddedTrip: Bool, errorMessage: String) {
        var hasAddedTrip = false
        var errorMessage = ""

        do {
            let newTripRef = try db.collection(FirebaseConfig.tripCollectionId).addDocument(from: trip)
            hasAddedTrip = true
            print("[FirebaseTripPersistenceManager] Added trip: \(newTripRef)")
        } catch {
            errorMessage = "[FirebaseTripPersistenceManager] Error adding trip: \(error)"
        }

        return (hasAddedTrip, errorMessage)
    }

    @MainActor
    func deleteTrip(trip: FirebaseAdaptedTrip) async -> (hasDeletedTrip: Bool, errorMessage: String) {
        var hasDeletedTrip = false
        var errorMessage: String = ""

        guard let id = trip.id else {
            return (hasDeletedTrip, errorMessage)
        }

        do {
            let deletedTripRef = db.collection(FirebaseConfig.tripCollectionId).document(id)
            try await deletedTripRef.delete()
            hasDeletedTrip = true
            print("[FirebaseTripPersistenceManager] Deleted trip: \(deletedTripRef)")
        } catch {
            errorMessage = "[FirebaseTripPersistenceManager] Error deleting trip: \(error)"
        }

        return (hasDeletedTrip, errorMessage)
    }

    @MainActor
    func updateTrip(trip: FirebaseAdaptedTrip) async -> (hasUpdatedTrip: Bool, errorMessage: String) {
        let (hasAddedTrip, errorMessage) = await addTrip(trip: trip)
        return (hasAddedTrip, errorMessage)
    }

}
