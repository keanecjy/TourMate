//
//  PlanViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class PlanViewModel<T: Plan>: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false
    @Published var plan: T
    @Published var isPlanDurationValid = true
    @Published var canEditPlan = true

    @Published private(set) var commentsViewModel: CommentsViewModel

    let trip: Trip
    let planController: PlanController

    private var cancellableSet: Set<AnyCancellable> = []

    init(plan: T, trip: Trip, planController: PlanController = FirebasePlanController()) {
        self.plan = plan
        self.trip = trip
        self.planController = planController
        self.commentsViewModel = CommentsViewModel(planId: plan.id)

        $plan
            .map({ $0.startDateTime.date <= $0.endDateTime.date })
            .assign(to: \.isPlanDurationValid, on: self)
            .store(in: &cancellableSet)

        $isPlanDurationValid
            .assign(to: \.canEditPlan, on: self)
            .store(in: &cancellableSet)
    }

    func fetchPlan() async {
        self.isLoading = true
        let (plan, errorMessage) = await planController.fetchPlan(withPlanId: plan.id)

        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        // no plans fetched
        guard plan != nil else {
            self.isDeleted = true
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

    private func modifyPlan(plan: T, function: (Plan) async -> (Bool, String)) async {
        self.isLoading = true

        let (hasUpdatedPlan, errorMessage) = await function(plan)

        guard hasUpdatedPlan, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }
        self.isLoading = false
    }

    func updatePlan() async {
        await modifyPlan(plan: plan) { plan in
            await planController.updatePlan(plan: plan)
        }
    }

    func deletePlan() async {
        await modifyPlan(plan: plan) { plan in
            await planController.deletePlan(plan: plan)
        }
    }
}
