//
//  UpvotePlanViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 7/4/22.
//

import Foundation

@MainActor
class PlanUpvoteViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published private(set) var userHasUpvotedPlan = false
    @Published private(set) var upvotedUsers: [User] = []

    let planId: String

    @Injected(\.planUpvoteService) var planUpvoteService: PlanUpvoteService
    @Injected(\.userService) var userService: UserService

    init(planId: String) {
        self.planId = planId
    }

    func fetchPlanUpvotesAndListen() async {
        planUpvoteService.planUpvoteEventDelegate = self

        self.isLoading = true
        await planUpvoteService.fetchPlanUpvotesAndListen(withPlanId: planId)
    }

    func detachListener() {
        planUpvoteService.planUpvoteEventDelegate = nil
        self.isLoading = false

        planUpvoteService.detachListener()
    }

    func upvotePlan() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()

        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let userId = user.id
        let planUpvote = PlanUpvote(planId: planId, userId: userId)

        var updateSuccess: Bool
        var errorMessage: String

        if userHasUpvotedPlan {
            (updateSuccess, errorMessage) = await planUpvoteService.deletePlanUpvote(planUpvote: planUpvote)
        } else {
            (updateSuccess, errorMessage) = await planUpvoteService.addPlanUpvote(planUpvote: planUpvote)
        }

        guard updateSuccess, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}

// MARK: - PlanUpvoteEventDelegate
extension PlanUpvoteViewModel: PlanUpvoteEventDelegate {
    func update(planUpvotes: [PlanUpvote], errorMessage: String) async {
        print("[PlanUpvoteViewModel] Updating Plan Upvotes")

        guard errorMessage.isEmpty else {
            handleError()
            return
        }

        let (currentUser, currentUserErrorMessage) = await userService.getCurrentUser()

        guard let currentUser = currentUser, currentUserErrorMessage.isEmpty else {
            print("[PlanUpvoteViewModel] fetch user failed as Delegate")
            handleError()
            return
        }

        let userIds = planUpvotes.map({ $0.userId })

        self.userHasUpvotedPlan = userIds.contains(currentUser.id)

        var upvotedUsers: [User] = []

        for userId in userIds {
            let (user, userErrorMessage) = await userService.getUser(withUserId: userId)

            if !userErrorMessage.isEmpty {
                print("[PlanUpvoteViewModel] User cannot be found, upvote will not render")
                continue
            }

            if let user = user {
                upvotedUsers.append(user)
            }
        }

        self.upvotedUsers = upvotedUsers

        self.isLoading = false
    }
}

// MARK: - Helper Methods
extension PlanUpvoteViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}
