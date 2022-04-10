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

    @Published private(set) var planOwner = User.defaultUser()

    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime

    private let userService: UserService
    private var planService: PlanService

    init(plan: Plan, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService, userService: UserService) {
        self.plan = plan
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.planService = planService
        self.userService = userService
    }

    var creationDateDisplay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = plan.startDateTime.timeZone
        return dateFormatter.string(from: plan.creationDate)
    }

    var lastModifiedDateDisplay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = plan.startDateTime.timeZone
        return dateFormatter.string(from: plan.modificationDate)
    }

    var planId: String {
        plan.id
    }

    var versionNumber: Int {
        plan.versionNumber
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

        guard !plans.isEmpty else {
            handleDeletion()
            return
        }

        loadLatestVersionedPlan(plans)
    }

}

// MARK: - Helper Methods
extension PlanViewModel {
    private func loadLatestVersionedPlan(_ plans: [Plan]) {
        var latestPlan = plans[0]

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        self.plan = latestPlan
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
