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
        PlanViewModel(plan: plan, allVersionedPlans: allVersionedPlansSortedDesc,
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

        guard let plan = allVersionedPlansSortedDesc.first(where: { $0.versionNumber == versionNumber }) else {
            print("[PlanViewModel] Not able to find plan with version \(versionNumber)")
            return
        }

        await update(plan: plan, errorMessage: "")
    }

    func restoreToCurrentVersion() async {
        let (currentUser, userError) = await userService.getCurrentUser()

        guard let currentUser = currentUser, userError.isEmpty else {
            handleError()
            return
        }

        plan.versionNumber = latestVersionNumber + 1
        plan.modificationDate = Date()
        plan.modifierUserId = currentUser.id

        let (additionSuccess, additionError) = await planService.addPlan(plan: plan)
        guard additionSuccess, additionError.isEmpty else {
            handleError()
            return
        }
    }

    func diffPlan(with viewModel: PlanViewModel) -> PlanDiffMap {
        plan.diff(other: viewModel.plan)
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

        self.allVersionedPlansSortedDesc = plans.sorted(by: { $0.versionNumber > $1.versionNumber })

        await loadLatestVersionedPlan()
        await updateDelegates()
        await updatePlanLastModifier()
        await updatePlanModifierMap()
    }

}

// MARK: - Helper Methods
extension PlanViewModel {
    private func loadLatestVersionedPlan() async {
        guard let latestPlan = allVersionedPlansSortedDesc.first else {
            handleDeletion()
            return
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

    private func updatePlanModifierMap() async {
        var seenUsers: [String: User] = [:]

        for plan in allVersionedPlansSortedDesc {
            if let user = seenUsers[plan.modifierUserId] {
                planModifierMap[plan.versionNumber] = user
            } else {
                let (user, _) = await userService.getUser(withUserId: plan.modifierUserId)
                if let user = user {
                    planModifierMap[plan.versionNumber] = user
                    seenUsers[user.id] = user
                }
            }
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
