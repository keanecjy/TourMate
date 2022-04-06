//
//  EditPlanViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import Foundation

@MainActor
class EditPlanViewModel: PlanFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    private(set) var canDeletePlan = false

    private let plan: Plan

    private let planService: PlanService
    private let userService: UserService

    init(plan: Plan, lowerBoundDate: DateTime, upperBoundDate: DateTime,
         planService: PlanService = FirebasePlanService(),
         userService: UserService = FirebaseUserService()) {

        self.plan = plan
        self.planService = planService
        self.userService = userService

        super.init(lowerBoundDate: lowerBoundDate.date, upperBoundDate: upperBoundDate.date, plan: plan)

        Task {
            let (user, _) = await userService.getCurrentUser()
            if let user = user,
               user.id == plan.ownerUserId {
                canDeletePlan = true
                canChangeStatus = true
            } else {
                canDeletePlan = false
                canChangeStatus = false
            }
        }
    }

    func updatePlan() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let id = plan.id
        let tripId = plan.tripId
        let name = planName
        let startDateTime = DateTime(date: planStartDate, timeZone: plan.startDateTime.timeZone)
        let endDateTime = DateTime(date: planEndDate, timeZone: plan.endDateTime.timeZone)
        let startLocation = planStartLocation
        let endLocation = planEndLocation
        let imageUrl = planImageUrl
        let status = planStatus
        let creationDate = plan.creationDate
        let upvotedUserIds = plan.upvotedUserIds
        let additionalInfo = planAdditionalInfo
        let ownerUserId = user.id

        let updatedPlan = Plan(id: id,
                               tripId: tripId,
                               name: name,
                               startDateTime: startDateTime,
                               endDateTime: endDateTime,
                               startLocation: startLocation,
                               endLocation: endLocation,
                               imageUrl: imageUrl,
                               status: status,
                               creationDate: creationDate,
                               modificationDate: Date(),
                               upvotedUserIds: upvotedUserIds,
                               additionalInfo: additionalInfo,
                               ownerUserId: ownerUserId)

        let (hasUpdatedPlan, errorMessage) = await planService.updatePlan(plan: updatedPlan)

        guard hasUpdatedPlan, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
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

// MARK: - Helper Methods
extension EditPlanViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }

    private func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }
}
