//
//  AddAccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import Foundation

@MainActor
class AddAccommodationViewModel: AccommodationFormViewModel {
    var trip: Trip

    init(trip: Trip, planService: PlanService, userService: UserService) {
        self.trip = trip

        super.init(lowerBoundDate: trip.startDateTime.date,
                   upperBoundDate: trip.endDateTime.date,
                   planService: planService,
                   userService: userService)
    }

    func addAccommodation() async {
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

        let accommodation = Accommodation(
            id: planId,
            tripId: tripId,
            name: name,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            imageUrl: imageUrl,
            status: status,
            creationDate: creationDate,
            modificationDate: modificationDate,
            additionalInfo: additionalInfo,
            ownerUserId: ownerUserId,
            location: location)

        let (hasAddedAccommodation, errorMessage) = await planService.addPlan(plan: accommodation)
        guard hasAddedAccommodation, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}
