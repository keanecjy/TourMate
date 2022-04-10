//
//  PlanViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class PlanViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var plan: Plan
    var allPlans: [Plan]

    @Published private(set) var planOwner = User.defaultUser()

    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime

    private let userService: UserService
    private var planService: PlanService

    var planEventDelegates: [PlanEventDelegate]

    init(plan: Plan, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService, userService: UserService) {
        self.plan = plan
        self.allPlans = [plan]
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.planService = planService
        self.userService = userService

        self.planEventDelegates = []
    }

    var creationDateDisplay: String {
        DateUtil.defaultDateDisplay(date: plan.creationDate, at: plan.startDateTime.timeZone)
    }

    var lastModifiedDateDisplay: String {
        DateUtil.defaultDateDisplay(date: plan.modificationDate, at: plan.startDateTime.timeZone)
    }

    var planId: String {
        plan.id
    }

    var versionNumber: Int {
        plan.versionNumber
    }

    var allVersionNumbers: [Int] {
        allPlans.map({ $0.versionNumber }).sorted(by: { a, b in a > b })
    }

    var nameDisplay: String {
        plan.name
    }

    var statusDisplay: PlanStatus {
        plan.status
    }

    var versionNumberDisplay: String {
        String(plan.versionNumber)
    }

    var startDateTimeDisplay: DateTime {
        plan.startDateTime
    }

    var endDateTimeDisplay: DateTime {
        plan.endDateTime
    }

    var startLocationDisplay: Location? {
        plan.startLocation
    }

    var endLocationDisplay: Location? {
        plan.endLocation
    }

    var additionalInfoDisplay: String {
        plan.additionalInfo
    }

    func attachDelegate(delegate: PlanEventDelegate) {
        self.planEventDelegates.append(delegate)
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

}

// MARK: - PlanEventDelegate
extension PlanViewModel: PlanEventDelegate {
    func update(plan: Plan?, errorMessage: String) async {}

    func update(plans: [Plan], errorMessage: String) async {
        print("[PlansViewModel] Updating Versioned Plans: \(plans)")

        guard errorMessage.isEmpty else {
            handleError()
            return
        }

        loadLatestVersionedPlan(plans)
        await updateDelegates()
    }

}

// MARK: - Helper Methods
extension PlanViewModel {
    private func loadLatestVersionedPlan(_ plans: [Plan]) {
        guard var latestPlan = plans.first else {
            handleDeletion()
            return
        }

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        self.plan = latestPlan
        self.allPlans = plans
    }

    private func updateDelegates() async {
        for eventDelegate in self.planEventDelegates {
            await eventDelegate.update(plan: self.plan, errorMessage: "")
        }
    }
}

// MARK: - State changes
extension PlanViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }

    private func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }
}
