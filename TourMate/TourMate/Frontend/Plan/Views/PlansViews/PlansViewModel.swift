//
//  PlansViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 17/3/22.
//

import Foundation

@MainActor
class PlansViewModel: ObservableObject {
    @Published private(set) var plans: [Plan]
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool

    private var planService: PlanService

    init(planService: PlanService = FirebasePlanService()) {
        self.plans = []
        self.isLoading = false
        self.hasError = false
        self.planService = planService
    }

    func fetchPlans(withTripId tripId: String) async {
        self.isLoading = true

        let (plans, errorMessage) = await planService.fetchPlans(withTripId: tripId)
        loadPlans(plans: plans, errorMessage: errorMessage)
    }

    func fetchPlansAndListen(withTripId tripId: String) async {
        planService.planEventDelegate = self

        self.isLoading = true
        await planService.fetchPlansAndListen(withTripId: tripId)
    }

    func detachListener() {
        planService.planEventDelegate = nil
        self.isLoading = false

        planService.detachListener()
    }
}

// MARK: - PlanEventDelegate
extension PlansViewModel: PlanEventDelegate {
    func update(plans: [Plan], errorMessage: String) async {
        print("[PlansViewModel] Updating Plans: \(plans)")

        loadPlans(plans: plans, errorMessage: errorMessage)
    }

    func update(plan: Plan?, errorMessage: String) async {}
}

// MARK: - Helper Methods
extension PlansViewModel {
    private func loadPlans(plans: [Plan], errorMessage: String) {
        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.plans = plans
        self.isLoading = false
    }
}
