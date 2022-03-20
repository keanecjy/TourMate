//
//  AddPlanViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation

@MainActor
class AddPlanViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool

    let planController: PlanController

    init(planController: PlanController = FirebasePlanController()) {
        self.isLoading = false
        self.hasError = false
        self.planController = planController
    }

    func addPlan(_ plan: Plan) async {
        self.isLoading = true
        let (hasAddedPlan, errorMessage) = await planController.addPlan(plan: plan)
        guard hasAddedPlan, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }
}
