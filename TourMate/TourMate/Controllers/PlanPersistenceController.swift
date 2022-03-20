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

    func fetchPlans(withTripId tripId: String) async -> ([Plan], String) {
        let (adaptedPlans, errorMessage) = await firebasePersistenceManager
            .fetchItems(field: "tripId", isEqualTo: tripId)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        // unable to typecast
        guard let adaptedPlans = adaptedPlans as? [FirebaseAdaptedPlan] else {
            preconditionFailure()
            // Alternative
            // return ([], "Unable to convert FirebaseAdaptedData to FirebaseAdaptedPlan")
        }

        let plans = adaptedPlans.map({ PlanAdapter.toPlan(adaptedPlan: $0) })
        return (plans, "")
    }

    func fetchPlan(withPlanId planId: String) async -> (Plan?, String) {
        let (adaptedPlan, errorMessage) = await firebasePersistenceManager.fetchItem(id: planId)

        guard errorMessage.isEmpty else {
            return (nil, errorMessage)
        }

        guard adaptedPlan != nil else { // unable to get a adaptedPlan
            return (nil, "")
        }

        // unable to typecast
        guard let adaptedPlan = adaptedPlan as? FirebaseAdaptedPlan else {
            return (nil, "Unable to convert FirebaseAdaptedData to FirebaseAdaptedPlan")
        }

        let plan = PlanAdapter.toPlan(adaptedPlan: adaptedPlan)
        return (plan, "")
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: plan.id)
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: plan.id, item: PlanAdapter.toAdaptedPlan(plan: plan))
    }
}
