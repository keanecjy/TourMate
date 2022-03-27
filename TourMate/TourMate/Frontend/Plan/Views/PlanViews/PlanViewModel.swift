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

    @Published private(set) var userHasUpvotedPlan = false
    @Published private(set) var upvotedUsers: [User] = []

    let trip: Trip
    let planController: PlanController
    let userController: UserController

    private var cancellableSet: Set<AnyCancellable> = []

    init(plan: T, trip: Trip,
         planController: PlanController = FirebasePlanController(),
         userController: UserController = FirebaseUserController()) {
        self.plan = plan
        self.trip = trip
        self.planController = planController
        self.userController = userController

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
        var plan = self.plan

        if plan.upvotedUserIds.contains(id) {
            plan.upvotedUserIds = plan.upvotedUserIds.filter { $0 != id }
        } else {
            plan.upvotedUserIds.append(id)
        }

        return plan
    }

    private func updatePublishedProperties(plan: T) async {
        self.plan = plan
        self.upvotedUsers = await fetchUpvotedUsers()

        let (currentUser, _) = await userController.getUser()
        self.userHasUpvotedPlan = self.upvotedUsers.contains(where: { $0.id == currentUser?.id })
    }

    private func fetchUpvotedUsers() async -> [User] {
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
