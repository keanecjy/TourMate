//
//  FirebasePlanService.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

struct FirebasePlanService: PlanService {

    private let firebasePersistenceManager = FirebasePersistenceManager(collectionId: FirebaseConfig.planCollectionId)

    private let planAdapter = PlanAdapter()

    func addPlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: plan.id, item: planAdapter.toAdaptedPlan(plan: plan))
    }

    func fetchPlans(withTripId tripId: String) async -> ([Plan], String) {
        let (adaptedPlans, errorMessage) = await firebasePersistenceManager
            .fetchItems(field: "tripId", isEqualTo: tripId)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        // unable to typecast
        guard let adaptedPlans = adaptedPlans as? [FirebaseAdaptedPlan] else {
             return ([], "Unable to convert FirebaseAdaptedData to FirebaseAdaptedPlan")
        }

        let plans = adaptedPlans.map({ planAdapter.toPlan(adaptedPlan: $0) })
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

        let plan = planAdapter.toPlan(adaptedPlan: adaptedPlan)
        return (plan, "")
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: plan.id)
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: plan.id, item: planAdapter.toAdaptedPlan(plan: plan))
    }
}
