//
//  FirebasePlanService.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

struct FirebasePlanService: PlanService {
    private let firebaseRepository = FirebaseRepository(collectionId: FirebaseConfig.planCollectionId)

    private let planAdapter = PlanAdapter()

    weak var planEventDelegate: PlanEventDelegate?

    func addPlan(plan: Plan) async -> (Bool, String) {
        print("[FirebasePlanService] Adding plan")

        return await firebaseRepository.addItem(id: plan.id, item: planAdapter.toAdaptedPlan(plan: plan))
    }

    func fetchPlansAndListen(withTripId tripId: String) async {
        print("[FirebasePlanService] Fetching and listening to plans")

        await firebaseRepository
            .fetchItemsAndListen(field: "tripId", isEqualTo: tripId,
                                 callback: { items, errorMessage in await self.update(items: items, errorMessage: errorMessage) })
    }

    func fetchPlanAndListen(withPlanId planId: String) async {
        print("[FirebasePlanService] Fetching and listening to plan")

        await firebaseRepository
            .fetchItemAndListen(id: planId,
                                callback: { item, errorMessage in await self.update(item: item, errorMessage: errorMessage) })
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        print("[FirebasePlanService] Deleting plan")

        return await firebaseRepository.deleteItem(id: plan.id)
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        print("[FirebasePlanService] Updating plan")

        return await firebaseRepository.updateItem(id: plan.id, item: planAdapter.toAdaptedPlan(plan: plan))
    }

    func detachListener() {
        firebaseRepository.detachListener()
    }

}

// MARK: - FirebaseEventDelegate
extension FirebasePlanService {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        print("[FirebasePlanService] Updating plans")

        guard errorMessage.isEmpty else {
            await planEventDelegate?.update(plans: [], errorMessage: errorMessage)
            return
        }

        guard let adaptedPlans = items as? [FirebaseAdaptedPlan] else {
            await planEventDelegate?.update(plans: [], errorMessage: Constants.errorPlanConversion)
            return
        }

        let plans = adaptedPlans
            .map({ planAdapter.toPlan(adaptedPlan: $0) })

        await planEventDelegate?.update(plans: plans, errorMessage: errorMessage)
    }

    func update(item: FirebaseAdaptedData?, errorMessage: String) async {
        print("[FirebasePlanService] Updating single plan")

        guard errorMessage.isEmpty,
              item != nil
        else {
            await planEventDelegate?.update(plan: nil, errorMessage: errorMessage)
            return
        }

        // unable to typecast
        guard let adaptedPlan = item as? FirebaseAdaptedPlan else {
            await planEventDelegate?.update(plan: nil, errorMessage: Constants.errorPlanConversion)
            return
        }

        let plan = planAdapter.toPlan(adaptedPlan: adaptedPlan)
        await planEventDelegate?.update(plan: plan, errorMessage: errorMessage)
    }
}
