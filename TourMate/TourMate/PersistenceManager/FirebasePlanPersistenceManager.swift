//
//  FirebasePlanPersistenceManager.swift
//  TourMate
//
//  Created by Keane Chan on 19/3/22.
//

import Firebase

struct FirebasePlanPersistenceManager {
    let collectionId: String = FirebaseConfig.planCollectionId

    private let db = Firestore.firestore()

    @MainActor
    func fetchPlans(tripId: String) async -> (items: [FirebaseAdaptedPlan], errorMessage: String) {
        let query = db.collection(collectionId).whereField("tripId", isEqualTo: tripId)
        do {
            let documents = try await query.getDocuments().documents
            let items = documents
                .compactMap({ convertPlan($0) })
                .sorted(by: { p1, p2 in p1.creationDate < p2.creationDate })
            return (items, "")
        } catch {
            let errorMessage = "[FirebasePlanPersistenceManager] Error fetching Plans: \(error)"
            return ([], errorMessage)
        }
    }

    func convertPlan(_ documentSnapshot: QueryDocumentSnapshot) -> FirebaseAdaptedPlan? {
        guard let planType = documentSnapshot.get("planType") as? String,
              let convertedPlanType = PlanType(rawValue: planType)
        else {
            return nil
        }
        
        switch convertedPlanType {
        case .accommodation:
            return try? documentSnapshot.data(as: FirebaseAdaptedAccommodation.self)
        case .activity:
            return try? documentSnapshot.data(as: FirebaseAdaptedActivity.self)
        case .restaurant:
            return try? documentSnapshot.data(as: FirebaseAdaptedRestaurant.self)
        case .transport:
            return try? documentSnapshot.data(as: FirebaseAdaptedTransport.self)
        case .flight:
            return try? documentSnapshot.data(as: FirebaseAdaptedFlight.self)
        }
    }
}
