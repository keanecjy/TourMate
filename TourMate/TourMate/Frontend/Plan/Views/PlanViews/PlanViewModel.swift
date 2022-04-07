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

    @Published private(set) var userHasUpvotedPlan = false
    @Published private(set) var upvotedUsers: [User] = []

    @Published private(set) var planOwner = User.defaultUser()

    let lowerBoundDate: DateTime
    let upperBoundDate: DateTime

    private let userService: UserService
    private var planService: PlanService

    init(plan: Plan, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService = FirebasePlanService(),
         userService: UserService = FirebaseUserService()) {

        self.plan = plan
        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate
        self.planService = planService
        self.userService = userService
        updatePlanOwner()
    }

    var creationDateDisplay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = plan.startDateTime.timeZone
        return dateFormatter.string(from: plan.creationDate)
    }

    var shortDurationDescriptionDisplay: String {
        var description = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = plan.startDateTime.timeZone
        description += dateFormatter.string(from: plan.startDateTime.date)

        description += " - "

        dateFormatter.timeZone = plan.endDateTime.timeZone
        description += dateFormatter.string(from: plan.endDateTime.date)

        return description
    }
    
    var planId: String {
        plan.id
    }

    var nameDisplay: String {
        plan.name
    }

    var statusDisplay: PlanStatus {
        plan.status
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

    func updatePlanOwner() {
        Task {
            let (user, _) = await userService.getUser(withUserId: plan.ownerUserId)
            if let user = user {
                planOwner = user
            }
        }
    }

    func fetchPlanAndListen() async {
        planService.planEventDelegate = self

        self.isLoading = true
        await planService.fetchPlanAndListen(withPlanId: plan.id)
        self.isLoading = false
    }

    func detachListener() {
        planService.planEventDelegate = nil
        self.isLoading = false

        planService.detachListener()
    }

    func upvotePlan() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()

        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let userId = user.id
        let updatedPlan = updateUpvotes(id: userId)

        let (hasUpdatedPlan, planErrorMessage) = await planService.updatePlan(plan: updatedPlan)

        guard hasUpdatedPlan, planErrorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }

    private func updateUpvotes(id: String) -> Plan {
        var plan = self.plan

        if plan.upvotedUserIds.contains(id) {
            plan.upvotedUserIds = plan.upvotedUserIds.filter { $0 != id }
        } else {
            plan.upvotedUserIds.append(id)
        }

        return plan
    }

    // Update all plans
    private func updatePublishedProperties(plan: Plan) async {
        print("[PlanViewModel] Publishing plan \(plan) changes")
        self.plan = plan
        self.upvotedUsers = await fetchUpvotedUsers()

        let (currentUser, _) = await userService.getCurrentUser()
        self.userHasUpvotedPlan = self.upvotedUsers.contains(where: { $0.id == currentUser?.id })
    }

    private func fetchUpvotedUsers() async -> [User] {
        var fetchedUpvotedUsers: [User] = []

        for userId in plan.upvotedUserIds {
            let (user, userErrorMessage) = await userService.getUser(withUserId: userId)

            if !userErrorMessage.isEmpty {
                print("[PlanViewModel] Error fetching user: \(userErrorMessage)")
                continue
            }

            if let user = user {  // maybe no user with that Id (deleted?)
                fetchedUpvotedUsers.append(user)
            }
        }

        return fetchedUpvotedUsers
    }
}

// MARK: - PlanEventDelegate
extension PlanViewModel: PlanEventDelegate {
    func update(plan: Plan?, errorMessage: String) async {
        print("[PlanViewModel] Updating Single Plan")

        guard errorMessage.isEmpty else {
            handleError()
            return
        }

        guard plan != nil else {
            handleDeletion()
            return
        }

        guard let plan = plan else {
            handleError()
            return
        }

        await updatePublishedProperties(plan: plan)

        self.isLoading = false
    }

    func update(plans: [Plan], errorMessage: String) async {}
}

// MARK: - Helper Methods
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
