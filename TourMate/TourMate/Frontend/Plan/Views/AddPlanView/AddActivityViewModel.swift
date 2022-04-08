//
//  AddActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class AddActivityViewModel: PlanFormViewModel {
    @Published private(set) var isLoading = false
    @Published private(set) var hasError = false

    @Published var location: Location?

    private let trip: Trip
    private let planService: PlanService
    private let userService: UserService

    init(trip: Trip, planService: PlanService = FirebasePlanService(), userService: UserService = FirebaseUserService()) {

        self.trip = trip
        self.planService = planService
        self.userService = userService

        super.init(lowerBoundDate: trip.startDateTime.date, upperBoundDate: trip.endDateTime.date)
    }

    func addActivity() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let planId = trip.id + UUID().uuidString
        let tripId = trip.id
        let name = planName
        let startDateTime = DateTime(date: planStartDate, timeZone: trip.startDateTime.timeZone)
        let endDateTime = DateTime(date: planEndDate, timeZone: trip.endDateTime.timeZone)
        let imageUrl = planImageUrl
        let status = planStatus
        let creationDate = Date()
        let modificationDate = Date()
        let additionalInfo = planAdditionalInfo
        let ownerUserId = user.id

        let activity = Activity(id: planId,
                                tripId: tripId,
                                name: name,
                                startDateTime: startDateTime,
                                endDateTime: endDateTime,
                                imageUrl: imageUrl, status: status, creationDate: creationDate,
                                modificationDate: modificationDate,
                                additionalInfo: additionalInfo,
                                ownerUserId: ownerUserId,
                                location: location)

        let (hasAddedActivity, errorMessage) = await planService.addPlan(plan: activity)
        guard hasAddedActivity, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}

// MARK: - State changes
extension AddActivityViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}
