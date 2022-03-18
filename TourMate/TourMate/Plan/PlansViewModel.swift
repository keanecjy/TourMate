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

    private let planService: PlanPersistenceControllerProtocol
    var tripId: String

    init(planService: PlanPersistenceControllerProtocol = PlanPersistenceController(), tripId: String = "") {
        self.plans = []
        self.isLoading = false
        self.planService = planService
        self.tripId = tripId
    }

    func fetchPlans() async {
        self.isLoading = true
        let (plans, errorMessage) = await planService.fetchPlans(withTripId: tripId)
        guard errorMessage == "" else {
            return
        }
        self.plans = plans
        self.isLoading = false
    }
}
