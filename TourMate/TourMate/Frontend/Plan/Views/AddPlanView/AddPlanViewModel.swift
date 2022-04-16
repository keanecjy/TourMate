//
//  AddPlanViewModel.swift
//  TourMate
//
//  Created by Keane Chan on 12/4/22.
//

import Foundation
import Combine

@MainActor
class AddPlanViewModel<T: Plan>: PlanFormViewModel<T> {
    private let trip: Trip

    private let planService: PlanService
    private let userService: UserService

    init(trip: Trip, planService: PlanService, userService: UserService) {

        self.trip = trip
        self.planService = planService
        self.userService = userService

        super.init(lowerBoundDate: trip.startDateTime.date, upperBoundDate: trip.endDateTime.date)
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
                    endDateTime: DateTime(date: planEndDate, timeZone: trip.endDateTime.timeZone),
                    imageUrl: planImageUrl,
                    status: planStatus,
                    additionalInfo: planAdditionalInfo,
                    ownerUserId: user.id)
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

    func getTripLocation() -> Location {
        trip.location
    }

    func addPlan() async {}

}
