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

    var upvotedUsersPerVersion: [Int: [User]] = [:]

    let planId: String
    var planVersion: Int

    private let userService: UserService
    private var planUpvoteService: PlanUpvoteService

    init(planId: String,
         planVersionNumber: Int,
         userService: UserService,
         planUpvoteService: PlanUpvoteService) {

        self.planId = planId
        self.planVersion = planVersionNumber
        self.userService = userService
        self.planUpvoteService = planUpvoteService
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
        let planUpvote = PlanUpvote(planId: planId, userId: userId, planVersion: planVersion)

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

        let userIdMap = await fetchUsers(from: planUpvotes)

        var upvotedUsersPerVersion: [Int: [User]] = [:]

        for planUpvote in planUpvotes {
            let userId = planUpvote.userId
            let planVersion = planUpvote.planVersion

            guard let user = userIdMap[userId] else {
                continue
            }

            var arr = upvotedUsersPerVersion[planVersion] ?? []
            arr.append(user)
            upvotedUsersPerVersion[planVersion] = arr
        }

        self.upvotedUsersPerVersion = upvotedUsersPerVersion
        await updateCurrentVersionUpvotedUsers()
        self.isLoading = false
    }
}

// MARK: - Helper Methods
extension PlanUpvoteViewModel {
    private func fetchUsers(from planUpvotes: [PlanUpvote]) async -> [String: User] {
        var userIdMap: [String: User] = [:]

        for planUpvote in planUpvotes {
            guard userIdMap[planUpvote.userId] == nil else {
                continue
            }

            let (user, userErrorMessage) = await userService.getUser(withUserId: planUpvote.userId)

            guard let user = user,
                  userErrorMessage.isEmpty
            else {
                print("[PlanUpvoteViewModel] User cannot be found, upvote will not render")
                continue
            }

            userIdMap[user.id] = user
        }

        return userIdMap
    }

    private func updateCurrentVersionUpvotedUsers() async {
        let currentUser = await fetchCurrentUser()

        self.upvotedUsers = upvotedUsersPerVersion[planVersion] ?? []
        self.userHasUpvotedPlan = upvotedUsers.contains(currentUser)
    }

    private func fetchCurrentUser() async -> User {
        let (currentUser, currentUserErrorMessage) = await userService.getCurrentUser()

        guard let currentUser = currentUser, currentUserErrorMessage.isEmpty else {
            print("[PlanUpvoteViewModel] Fetch current user failed")
            handleError()
            return User.defaultUser()
        }

        return currentUser
    }

    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}

// MARK: - PlanEventDelegate
extension PlanUpvoteViewModel: PlanEventDelegate {
    func update(plans: [Plan], errorMessage: String) async {
    }

    func update(plan: Plan?, errorMessage: String) async {
        guard let plan = plan else {
            return
        }

        print("[PlanUpvoteViewModel] Updating to plan version number \(plan.versionNumber)")

        // Fetch new version upvotes
        if planVersion != plan.versionNumber {
            planVersion = plan.versionNumber

            await updateCurrentVersionUpvotedUsers()
        }
    }
}
