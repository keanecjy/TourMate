//
//  EditTransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation
import SwiftUI

@MainActor
class EditTransportViewModel: TransportFormViewModel {

    init(transport: Transport,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   transport: transport,
                   planService: planService,
                   userService: userService)
    }

    func updateTransport() async {
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

        let updatedTransport = Transport(
            id: planId, tripId: tripId,
            name: name, startDateTime: startDateTime,
            endDateTime: endDateTime, imageUrl: imageUrl,
            status: status, creationDate: creationDate,
            modificationDate: modificationDate,
            additionalInfo: additionalInfo,
            ownerUserId: ownerUserId,
            startLocation: startLocation,
            endLocation: endLocation)

        guard plan != updatedTransport else {
            self.isLoading = false
            return
        }

        await makeUpdatedPlan(updatedTransport)

        let (hasUpdatedTransport, errorMessage) = await planService.updatePlan(plan: updatedTransport)

        guard hasUpdatedTransport, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}
