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

    @Published private(set) var userHasUpvotedPlan: Bool
    @Published private(set) var upvotedUsers: [User]

    let planController: PlanController
    let userController: UserController
    var planId: String

    init(planController: PlanController = FirebasePlanController(),
         userController: UserController = FirebaseUserController(),
         planId: String) {
        self.isLoading = false
        self.hasError = false
        self.planController = planController
        self.userController = userController
        self.planId = planId

        self.userHasUpvotedPlan = false
        self.upvotedUsers = []
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

        await updatePublishedProperties(plan: plan)

        self.isLoading = false
    }

    func upvotePlan() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userController.getUser()

        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        let userId = user.id

        // there's no plan -> not error
        guard let updatedPlan = updateUpvotes(id: userId) else {
            self.isLoading = false
            return
        }

        let (hasUpdatedPlan, planErrorMessage) = await planController.updatePlan(plan: updatedPlan)

        guard hasUpdatedPlan, planErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        await updatePublishedProperties(plan: updatedPlan)

        self.isLoading = false
    }

    private func updateUpvotes(id: String) -> T? {
        guard var plan = plan else {
            return nil
        }

        if plan.upvotedUserIds.contains(id) {
            plan.upvotedUserIds = plan.upvotedUserIds.filter { $0 != id }
        } else {
            plan.upvotedUserIds.append(id)
        }

        return plan
    }

    private func updatePublishedProperties(plan: T?) async {
        self.plan = plan
        self.upvotedUsers = await fetchUpvotedUsers()

        let (currentUser, _) = await userController.getUser()
        self.userHasUpvotedPlan = self.upvotedUsers.contains(where: { $0.id == currentUser?.id })
    }

    private func fetchUpvotedUsers() async -> [User] {
        guard let plan = plan else {
            return []
        }

        var fetchedUpvotedUsers: [User] = []

        for userId in plan.upvotedUserIds {
            let (user, userErrorMessage) = await userController.getUser(with: "id", value: userId)

            if !userErrorMessage.isEmpty {
                print("Error fetching user")
                continue
            }

            if let user = user {  // maybe no user with that Id (deleted?)
                fetchedUpvotedUsers.append(user)
            }
        }

        return fetchedUpvotedUsers
    }
}
