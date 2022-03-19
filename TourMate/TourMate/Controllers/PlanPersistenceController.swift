//
//  PlanPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

struct PlanPersistenceController {
    let firebasePersistenceManager = FirebasePersistenceManager(collectionId: FirebaseConfig.planCollectionId)

    func addPlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: plan.id, item: PlanAdapter.toAdaptedPlan(plan: plan))
    }

    func fetchPlans(tripId: String) async -> ([Plan], String) {
        let (adaptedPlans, errorMessage) = await firebasePersistenceManager
            .fetchItems(field: "tripId", isEqualTo: tripId)

        guard let adaptedPlans = adaptedPlans as? [FirebaseAdaptedPlan] else {
            preconditionFailure()
        }

        let plans = adaptedPlans.map({ PlanAdapter.toPlan(adaptedPlan: $0) })
        return (plans, errorMessage)
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: plan.id)
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: plan.id, item: PlanAdapter.toAdaptedPlan(plan: plan))
    }
}
