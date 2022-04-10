//
//  FirebasePlanService.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

import FirebaseAuth

class FirebasePlanService: PlanService {
    required init() {

    }

    private let planRepository = FirebaseRepository(collectionId: FirebaseConfig.planCollectionId)

    private let planAdapter = PlanAdapter()

    weak var planEventDelegate: PlanEventDelegate?

    func addPlan(plan: Plan) async -> (Bool, String) {
        print("[FirebasePlanService] Adding plan")

        return await planRepository.addItem(id: plan.versionedId, item: planAdapter.toAdaptedPlan(plan: plan))
    }

    func fetchPlansAndListen(withTripId tripId: String) async {
        print("[FirebasePlanService] Fetching and listening to plans")

        planRepository.eventDelegate = self
        await planRepository.fetchItemsAndListen(field: "tripId", isEqualTo: tripId)
    }

    func fetchPlanAndListen(withPlanId planId: String) async {
        print("[FirebasePlanService] Fetching and listening to plan")

        planRepository.eventDelegate = self
        await planRepository.fetchItemAndListen(id: planId)
    }

    func fetchPlans(withPlanId planId: String) async -> ([Plan], String) {
        print("[FirebasePlanService] Fetching plans")

        let (adaptedPlans, errorMessage) = await planRepository.fetchItems(field: "planId", isEqualTo: planId)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        guard let adaptedPlans = adaptedPlans as? [FirebaseAdaptedPlan] else {
            return ([], Constants.errorPlanConversion)
        }

        let plans = adaptedPlans.map({ planAdapter.toPlan(adaptedPlan: $0) })

        return (plans, errorMessage)
    }

    func deletePlan(plan: Plan) async -> (Bool, String) {
        print("[FirebasePlanService] Deleting plan")

        let (plans, errorMessage) = await fetchPlans(withPlanId: plan.id)

        guard errorMessage.isEmpty else {
            return (false, errorMessage)
        }

        return await deleteAllVersionedPlans(plans)
    }

    private func deleteAllVersionedPlans(_ plans: [Plan]) async -> (Bool, String) {
        print("[FirebasePlanService] Deleting all versioned plans")

        var hasDeletedAllPlans = true
        var err = ""

        for plan in plans {
            let (hasDeletedItem, errorMessage) = await planRepository.deleteItem(id: plan.versionedId)

            guard hasDeletedItem,
                  errorMessage.isEmpty
            else {
                hasDeletedAllPlans = hasDeletedAllPlans && hasDeletedItem
                err = errorMessage
                continue
            }
        }

        return (hasDeletedAllPlans, err)
    }

    func updatePlan(plan: Plan) async -> (Bool, String) {
        print("[FirebasePlanService] Updating plan")

        return await planRepository.updateItem(id: plan.versionedId,
                                               item: planAdapter.toAdaptedPlan(plan: plan))
    }

    func detachListener() {
        planRepository.eventDelegate = nil
        planRepository.detachListener()
    }

}

// MARK: - FirebaseEventDelegate
extension FirebasePlanService: FirebaseEventDelegate {
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

        let plans = adaptedPlans.map({ planAdapter.toPlan(adaptedPlan: $0) })

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

        guard let adaptedPlan = item as? FirebaseAdaptedPlan else {
            await planEventDelegate?.update(plan: nil, errorMessage: Constants.errorPlanConversion)
            return
        }

        let plan = planAdapter.toPlan(adaptedPlan: adaptedPlan)
        await planEventDelegate?.update(plan: plan, errorMessage: errorMessage)
    }
}
