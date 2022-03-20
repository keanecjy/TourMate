//
//  EditPlanViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import Foundation

class EditPlanViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool
    @Published private(set) var hasError: Bool

    let planController: PlanController

    init(planController: PlanController = FirebasePlanController()) {
        self.isLoading = false
        self.hasError = false
        self.planController = planController
    }

    private func modifyPlan(plan: Plan, function: (Plan) async -> (Bool, String)) async {
        self.isLoading = true

        let (hasUpdatedPlan, errorMessage) = await function(plan)

        guard hasUpdatedPlan, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

    func updatePlan(plan: Plan) async {
        await modifyPlan(plan: plan) { plan in
            await planController.updatePlan(plan: plan)
        }
    }

    func deletePlan(plan: Plan) async {
        await modifyPlan(plan: plan) { plan in
            await planController.deletePlan(plan: plan)
        }
    }
}
