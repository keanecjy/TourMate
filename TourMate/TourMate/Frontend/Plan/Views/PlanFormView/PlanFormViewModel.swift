//
//  PlanFormViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 1/4/22.
//

import Foundation
import Combine

@MainActor
class PlanFormViewModel<T: Plan>: ObservableObject {
    let lowerBoundDate: Date
    let upperBoundDate: Date

    let plan: T // Store initial plan for edit
    let trip: Trip // Store trip details
    let planService: PlanService
    let userService: UserService

    @Published var isLoading = false
    @Published private(set) var hasError = false

    @Published var isPlanNameValid: Bool
    @Published var isPlanDurationValid: Bool
    @Published var canSubmitPlan: Bool

    @Published var planStatus: PlanStatus
    @Published var planName: String
    @Published var planStartDate: Date
    @Published var planEndDate: Date
    @Published var planImageUrl: String
    @Published var planAdditionalInfo: String

    @Published var canChangeStatus = true
    private(set) var canDeletePlan = false

    private var cancellableSet: Set<AnyCancellable> = []

    // Adding Plan
    init(trip: Trip, planService: PlanService, userService: UserService) {
        self.plan = T()
        self.trip = trip
        self.planService = planService
        self.userService = userService

        self.lowerBoundDate = trip.startDateTime.date
        self.upperBoundDate = trip.endDateTime.date

        self.isPlanNameValid = false
        self.isPlanDurationValid = true
        self.canSubmitPlan = false

        self.planStatus = .proposed
        self.planName = ""
        self.planStartDate = lowerBoundDate
        self.planEndDate = lowerBoundDate + TimeInterval(3_600) // 1 hour
        self.planImageUrl = ""
        self.planAdditionalInfo = ""

        validate()
    }

    // Editing Plan
    init(lowerBoundDate: Date, upperBoundDate: Date, plan: T,
         planService: PlanService, userService: UserService) {
        self.plan = plan
        self.trip = Trip()
        self.planService = planService
        self.userService = userService

        self.lowerBoundDate = lowerBoundDate
        self.upperBoundDate = upperBoundDate

        self.isPlanNameValid = true
        self.isPlanDurationValid = true
        self.canSubmitPlan = true

        self.planStatus = plan.status
        self.planName = plan.name
        self.planStartDate = plan.startDateTime.date
        self.planEndDate = plan.endDateTime.date
        self.planImageUrl = plan.imageUrl
        self.planAdditionalInfo = plan.additionalInfo

        validate()
        updatePermissions()
    }

    private func validate() {
        // Plan Constraints
        $planName
            .map({ !$0.isEmpty })
            .assign(to: \.isPlanNameValid, on: self)
            .store(in: &cancellableSet)

        Publishers
            .CombineLatest($planStartDate, $planEndDate)
            .map({ max($0, $1) })
            .assign(to: \.planEndDate, on: self)
            .store(in: &cancellableSet)

        // Within date boundaries
        Publishers
            .CombineLatest($planStartDate, $planEndDate)
            .map({ start, end in
                self.lowerBoundDate <= start &&
                start <= end &&
                end <= self.upperBoundDate
            })
            .assign(to: \.isPlanDurationValid, on: self)
            .store(in: &cancellableSet)

        // All validity checks satisfied
        Publishers
            .CombineLatest($isPlanNameValid, $isPlanDurationValid)
            .map({ $0 && $1 })
            .assign(to: \.canSubmitPlan, on: self)
            .store(in: &cancellableSet)

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

    func getPlanForAdding() async -> Plan {
        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            preconditionFailure()
        }

        return Plan(tripId: trip.id,
                    name: planName,
                    startDateTime: DateTime(date: planStartDate, timeZone: trip.startDateTime.timeZone),
                    endDateTime: DateTime(date: planStartDate, timeZone: trip.endDateTime.timeZone),
                    imageUrl: planImageUrl,
                    status: planStatus,
                    additionalInfo: planAdditionalInfo,
                    ownerUserId: user.id)
    }

    func deletePlan() async {
        self.isLoading = true

        let (hasDeleted, errorMessage) = await planService.deletePlan(plan: plan)

        guard hasDeleted, errorMessage.isEmpty else {
            handleError()
            return
        }
    }

    func addPlan(_ plan: T) async {
        self.isLoading = false

        let (hasAddedPlan, errorMessage) = await planService.addPlan(plan: plan)
        guard hasAddedPlan, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
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

// MARK: - State Changes
extension PlanFormViewModel {
    func handleError() {
        self.hasError = true
        self.isLoading = false
    }

}
