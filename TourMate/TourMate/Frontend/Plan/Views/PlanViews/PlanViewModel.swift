//
//  PlanViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class PlanViewModel<T: Plan>: PlanDisplayViewModel<T> {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime

    private let userService: UserService
    private var planService: PlanService

    var planEventDelegates: [PlanEventDelegate]

    init(plan: T, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService, userService: UserService) {

        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.planService = planService
        self.userService = userService

        self.planEventDelegates = []
        super.init(plan: plan)
    }

    init(plan: T, allVersionedPlans: [T],
         lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planOwner: User, planLastModifier: User,
         planService: PlanService, userService: UserService) {

        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.planService = planService
        self.userService = userService

        self.planEventDelegates = []
        super.init(plan: plan, allVersionedPlans: allVersionedPlans,
                   planOwner: planOwner, planLastModifier: planLastModifier)
    }

    func copy() -> PlanViewModel<T> {
        PlanViewModel(plan: plan, allVersionedPlans: allVersionedPlans,
                      lowerBoundDate: lowerBoundDate,
                      upperBoundDate: upperBoundDate,
                      planOwner: planOwner, planLastModifier: planLastModifier,
                      planService: planService.copy(), userService: userService)
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

    func setVersionNumber(_ versionNumber: Int) async {
        print("[PlanViewModel] Changing plan to version: \(versionNumber)")

        guard let plan = allVersionedPlans.first(where: { $0.versionNumber == versionNumber }) else {
            print("[PlanViewModel] Not able to find plan with version \(versionNumber)")
            return
        }

        await update(plan: plan, errorMessage: "")
    }

}

// MARK: - PlanEventDelegate
extension PlanViewModel: PlanEventDelegate {
    func update(plan: Plan?, errorMessage: String) async {
        guard errorMessage.isEmpty,
              let plan = plan as? T
        else {
            handleError()
            return
        }

        print("[PlanViewModel] Updating plan: \(plan)")

        self.plan = plan
        await updateDelegates()
        await updatePlanLastModifier()
    }

    func update(plans: [Plan], errorMessage: String) async {
        print("[PlanViewModel] Updating Versioned Plans: \(plans)")

        guard errorMessage.isEmpty,
              let plans = plans as? [T]
        else {
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
    private func loadLatestVersionedPlan(_ plans: [T]) {
        guard var latestPlan = plans.first else {
            handleDeletion()
            return
        }

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        self.plan = latestPlan
    }

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
