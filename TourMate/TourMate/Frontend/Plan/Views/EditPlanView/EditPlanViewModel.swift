//
//  EditPlanViewModel.swift
//  TourMate
//
//  Created by Keane Chan on 12/4/22.
//

import Foundation
import Combine

@MainActor
class EditPlanViewModel<T: Plan>: PlanFormViewModel<T> {
    private let plan: T

    private let planService: PlanService
    private let userService: UserService

    private(set) var canDeletePlan = false

    init(lowerBoundDate: Date, upperBoundDate: Date, plan: T,
         planService: PlanService, userService: UserService) {

        self.plan = plan
        self.planService = planService
        self.userService = userService

        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   plan: plan)

        updatePermissions()
    }

    func updatePermissions() {
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

    func getPlanWithUpdatedFields() -> Plan {
        Plan(id: plan.id,
             tripId: plan.tripId,
             name: planName,
             startDateTime: DateTime(date: planStartDate, timeZone: plan.startDateTime.timeZone),
             endDateTime: DateTime(date: planEndDate, timeZone: plan.endDateTime.timeZone),
             imageUrl: planImageUrl,
             status: planStatus,
             creationDate: plan.creationDate,
             modificationDate: plan.modificationDate,
             additionalInfo: planAdditionalInfo,
             ownerUserId: plan.ownerUserId,
             modifierUserId: plan.modifierUserId,
             versionNumber: plan.versionNumber)
    }

    func deletePlan() async {
        self.isLoading = true

        let (hasDeleted, errorMessage) = await planService.deletePlan(plan: plan)

        guard hasDeleted, errorMessage.isEmpty else {
            handleError()
            return
        }
    }

    func updatePlan(_ updatedPlan: T) async {
        guard !plan.equals(other: updatedPlan) else {
            self.isLoading = false
            return
        }

        await makeUpdatedPlan(updatedPlan)

        let (hasUpdatedPlan, errorMessage) = await planService.updatePlan(plan: updatedPlan)

        guard hasUpdatedPlan, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }

    func updatePlan() async {}

    private func makeUpdatedPlan(_ plan: T) async {
        let (currentUser, _) = await userService.getCurrentUser()
        guard let currentUser = currentUser else {
            handleError()
            return
        }

        plan.modificationDate = Date()
        plan.modifierUserId = currentUser.id
        plan.versionNumber += 1
    }

}
