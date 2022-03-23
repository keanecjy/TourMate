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

    let planController: PlanController
    var tripId: String

    init(planController: PlanController = FirebasePlanController(), tripId: String = "") {
        self.plans = []
        self.isLoading = false
        self.hasError = false
        self.planController = planController
        self.tripId = tripId
    }

    func fetchPlans() async {
        self.isLoading = true
        let (plans, errorMessage) = await planController.fetchPlans(withTripId: tripId)
        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.plans = plans
        self.isLoading = false
    }
}
