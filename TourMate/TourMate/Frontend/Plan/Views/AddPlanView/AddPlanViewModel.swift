//
//  AddPlanFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import Foundation
import Combine

@MainActor
class AddPlanViewModel: PlanFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    private let trip: Trip

    @Injected(\.planService) var planService: PlanService
    @Injected(\.userService) var userService: UserService

    init(trip: Trip) {
        self.trip = trip

        super.init(lowerBoundDate: trip.startDateTime.date, upperBoundDate: trip.endDateTime.date)
    }

    func addPlan() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let tripId = trip.id
        let planId = tripId + UUID().uuidString
        let name = planName
        let startDateTime = DateTime(date: planStartDate, timeZone: trip.startDateTime.timeZone)
        let endDateTime = DateTime(date: planEndDate, timeZone: trip.endDateTime.timeZone)
        let startLocation = planStartLocation
        let endLocation = planEndLocation
        let imageUrl = planImageUrl
        let status = planStatus
        let additionalInfo = planAdditionalInfo
        let ownerUserId = user.id

        let plan = Plan(id: planId,
                        tripId: tripId,
                        name: name,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime,
                        startLocation: startLocation,
                        endLocation: endLocation,
                        imageUrl: imageUrl,
                        status: status,
                        additionalInfo: additionalInfo,
                        ownerUserId: ownerUserId)

        let (hasAddedPlan, errorMessage) = await planService.addPlan(plan: plan)
        guard hasAddedPlan, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}

// MARK: - State changes
extension AddPlanViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}
