//
//  EditPlanViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import Foundation

@MainActor
class EditPlanViewModel: PlanFormViewModel {
    @Published var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    private(set) var canDeletePlan = false

    let plan: Plan
    let planService: PlanService
    private let userService: UserService

    init(plan: Plan, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService, userService: UserService) {

        self.plan = plan
        self.planService = planService
        self.userService = userService

        super.init(lowerBoundDate: lowerBoundDate.date, upperBoundDate: upperBoundDate.date, plan: plan)

        updatePermissions()
    }

    private func updatePermissions() {
        Task {
            let (currentUser, _) = await userService.getCurrentUser()
            if let currentUser = currentUser,
               currentUser.id == plan.ownerUserId {
                setSpecialPermissions(true)
            } else {
                setSpecialPermissions(false)
            }
        }
    }

    private func setSpecialPermissions(_ allowed: Bool) {
        canDeletePlan = allowed
        canChangeStatus = allowed
    }

    func deletePlan() async {
        self.isLoading = true

        let (hasDeleted, errorMessage) = await planService.deletePlan(plan: plan)

        guard hasDeleted, errorMessage.isEmpty else {
            handleError()
            return
        }
        handleDeletion()
    }
}

// MARK: - State changes
extension EditPlanViewModel {
    func handleError() {
        self.hasError = true
        self.isLoading = false
    }

    private func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }
}
