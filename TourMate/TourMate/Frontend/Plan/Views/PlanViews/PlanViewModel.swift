//
//  PlanViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class PlanViewModel: PlanDisplayViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime

    private let userService: UserService
    private var planService: PlanService

    var planEventDelegates: [PlanEventDelegate]

    init(plan: Plan, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService, userService: UserService) {

        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.planService = planService
        self.userService = userService

        self.planEventDelegates = []
        super.init(plan: plan)
    }

    func attachDelegate(delegate: PlanEventDelegate) {
        self.planEventDelegates.append(delegate)
    }

    func detachDelegates() {
        self.planEventDelegates = []
    }

    func updatePlanOwner() async {
        let (user, _) = await userService.getUser(withUserId: plan.ownerUserId)
        if let user = user {
            planOwner = user
        }
    }

    func fetchVersionedPlansAndListen() async {
        planService.planEventDelegate = self

        self.isLoading = true
        await planService.fetchVersionedPlansAndListen(withPlanId: plan.id)
        self.isLoading = false
    }

    func detachListener() {
        planService.planEventDelegate = nil
        self.isLoading = false

        planService.detachListener()
    }

    func loadLatestVersionedPlan(_ plans: [Plan]) {
        guard var latestPlan = plans.first else {
            handleDeletion()
            return
        }

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        self.plan = latestPlan
        self.allVersionedPlans = plans
    }
}

// MARK: - PlanEventDelegate
extension PlanViewModel: PlanEventDelegate {
    func update(plan: Plan?, errorMessage: String) async {}

    func update(plans: [Plan], errorMessage: String) async {
        print("[PlanViewModel] Updating Versioned Plans: \(plans)")

        guard errorMessage.isEmpty else {
            handleError()
            return
        }
        self.allVersionedPlans = plans

        loadLatestVersionedPlan(plans)
        await updateDelegates()
        await updatePlanLastModifier()
    }

}

// MARK: - Helper Methods
extension PlanViewModel {
    private func updateDelegates() async {
        for eventDelegate in self.planEventDelegates {
            await eventDelegate.update(plan: self.plan, errorMessage: "")
        }
    }

    private func updatePlanLastModifier() async {
        let (user, _) = await userService.getUser(withUserId: plan.modifierUserId)
        if let user = user {
            planLastModifier = user
        }
    }

}

// MARK: - State changes
extension PlanViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }

    func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }
}
