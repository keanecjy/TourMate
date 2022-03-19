//
//  PlanViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

@MainActor
class PlanViewModel<T: Plan>: ObservableObject {
    @Published private(set) var plan: T?
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool

    let planController: PlanPersistenceControllerProtocol
    var planId: String

    init(planController: PlanPersistenceControllerProtocol = MockPlanController(), planId: String) {
        self.isLoading = false
        self.hasError = false
        self.planController = planController
        self.planId = planId
    }

    func fetchPlan() async {
        self.isLoading = true
        let (plan, errorMessage) = await planController.fetchPlan(withPlanId: planId)
        guard let plan = plan as? T,
              errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.plan = plan
        self.isLoading = false
    }
}
