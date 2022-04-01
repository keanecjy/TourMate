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

    var trip: Trip
    let planService: PlanService

    private var cancellableSet: Set<AnyCancellable> = []

    init(trip: Trip, planService: PlanService = FirebasePlanService()) {

        self.trip = trip
        self.planService = planService

        super.init(lowerBoundDate: trip.startDateTime.date, upperBoundDate: trip.endDateTime.date)
    }

    func addPlan() async {
        self.isLoading = true

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

        let plan = Plan(id: planId,
                        tripId: tripId,
                        name: name,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime,
                        startLocation: startLocation,
                        endLocation: endLocation,
                        imageUrl: imageUrl,
                        status: status,
                        creationDate: Date(),
                        modificationDate: Date(),
                        upvotedUserIds: [],
                        additionalInfo: additionalInfo)

        let (hasAddedPlan, errorMessage) = await planService.addPlan(plan: plan)
        guard hasAddedPlan, errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        self.isLoading = false
    }
}
