//
//  PlanPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

struct PlanPersistenceController: PlanPersistenceControllerProtocol {

    let firebasePersistenceManager = FirebasePersistenceManager(collectionId: FirebaseConfig.planCollectionId)

    func addPlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: plan.id, item: PlanAdapter.toAdaptedPlan(plan: plan))
    }

    func fetchPlan(withPlanId planId: String) async -> (Plan, String) {
        let (adaptedPlan, errorMessage) = await firebasePersistenceManager.fetchItem(id: planId)
        guard let adaptedPlan = adaptedPlan as? FirebaseAdaptedPlan else {
            preconditionFailure()
        }

        let plan = PlanAdapter.toPlan(adaptedPlan: adaptedPlan)
        return (plan, errorMessage)
    }

    func fetchPlans(withTripId tripId: String) async -> ([Plan], String) {
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
