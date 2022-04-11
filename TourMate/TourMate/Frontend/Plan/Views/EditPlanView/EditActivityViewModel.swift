//
//  EditActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class EditActivityViewModel: ActivityFormViewModel {

    init(activity: Activity,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   activity: activity,
                   planService: planService,
                   userService: userService)
    }

    func updateActivity() async {
        self.isLoading = true

        let id = plan.id
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

        let updatedActivity = Activity(
            id: id, tripId: tripId, name: name,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            imageUrl: imageUrl, status: status,
            creationDate: creationDate,
            modificationDate: modificationDate,
            additionalInfo: additionalInfo,
            ownerUserId: ownerUserId,
            location: location)

        guard plan != updatedActivity else {
            self.isLoading = false
            return
        }

        await makeUpdatedPlan(updatedActivity)

        let (hasUpdatedActivity, errorMessage) = await planService.updatePlan(plan: updatedActivity)

        guard hasUpdatedActivity, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}
