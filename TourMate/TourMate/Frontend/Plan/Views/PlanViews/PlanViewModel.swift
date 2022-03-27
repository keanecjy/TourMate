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

    @Published private(set) var commentsViewModel: CommentsViewModel

    let planController: PlanController
    var planId: String

    init(planController: PlanController = FirebasePlanController(), planId: String) {
        self.isLoading = false
        self.hasError = false
        self.planController = planController
        self.planId = planId
        self.commentsViewModel = CommentsViewModel(planId: planId)
    }

    func fetchPlan() async {
        self.isLoading = true
        let (plan, errorMessage) = await planController.fetchPlan(withPlanId: planId)

        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        // no plans fetched
        guard plan != nil else {
            self.plan = nil
            self.isLoading = false
            return
        }

        // cannot cast fetched Plan into specific T-Plan
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
