//
//  PlanPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

struct PlanPersistenceController: PlanPersistenceControllerProtocol {
    // TODO: CRUD for plans - To think of better way to generalize things
    let firebasePersistenceManager = FirebasePersistenceManager<FirebaseAdaptedPlan>(collectionId: FirebaseConfig.planCollectionId)

    func fetchPlans(withTripId tripId: String) async -> ([Plan], String) {
        guard let user = Auth.auth().currentUser else {
            return ([], Constants.messageUserNotLoggedIn)
        }

        let (adaptedPlans, errorMessage) = await firebasePersistenceManager.fetchItems(field: "tripId", arrayContains: tripId)
        let plans = adaptedPlans.map({ $0.toItem() })
        return (plans, errorMessage)
    }

    mutating func addPlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: plan.id, item: plan.toData())
    }

    mutating func deletePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: plan.id)
    }

    mutating func updatePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: plan.id, item: plan.toData())
    }
}
