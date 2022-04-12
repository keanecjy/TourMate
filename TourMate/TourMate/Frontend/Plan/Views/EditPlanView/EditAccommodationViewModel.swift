//
//  EditAccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class EditAccommodationViewModel: AccommodationFormViewModel {

    init(accommodation: Accommodation,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   accommodation: accommodation, planService: planService,
                   userService: userService)
    }

    func updateAccommodation() async {
        self.isLoading = true

        let planId = plan.id
        let tripId = plan.tripId
        let name = planName
        let startDateTime = DateTime(date: planStartDate, timeZone: plan.startDateTime.timeZone)
        let endDateTime = DateTime(date: planEndDate, timeZone: plan.endDateTime.timeZone)
        let imageUrl = planImageUrl
        let status = planStatus
        let creationDate = plan.creationDate
        let modificationDate = Date()
        let additionalInfo = planAdditionalInfo
        let ownerUserId = plan.ownerUserId

        let updatedAccommodation = Accommodation(
            id: planId, tripId: tripId, name: name,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            imageUrl: imageUrl, status: status,
            creationDate: creationDate,
            modificationDate: modificationDate,
            additionalInfo: additionalInfo,
            ownerUserId: ownerUserId,
            location: location)

        guard !plan.equals(other: updatedAccommodation) else {
            self.isLoading = false
            return
        }

        await makeUpdatedPlan(updatedAccommodation)

        let (hasUpdatedAccommodation, errorMessage) = await planService.updatePlan(plan: updatedAccommodation)

        guard hasUpdatedAccommodation, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}
