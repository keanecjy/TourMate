//
//  AddTransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class AddTransportViewModel: TransportFormViewModel {
    var trip: Trip

    init(trip: Trip, planService: PlanService, userService: UserService) {
        self.trip = trip

        super.init(lowerBoundDate: trip.startDateTime.date,
                   upperBoundDate: trip.endDateTime.date,
                   planService: planService,
                   userService: userService)
    }

    func addTransport() async {
        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()
        guard let user = user, userErrorMessage.isEmpty else {
            handleError()
            return
        }

        let tripId = trip.id
        let name = planName
        let startDateTime = DateTime(date: planStartDate, timeZone: trip.startDateTime.timeZone)
        let endDateTime = DateTime(date: planEndDate, timeZone: trip.endDateTime.timeZone)
        let imageUrl = planImageUrl
        let status = planStatus
        let additionalInfo = planAdditionalInfo
        let ownerUserId = user.id

        let transport = Transport(tripId: tripId,
                                  name: name,
                                  startDateTime: startDateTime,
                                  endDateTime: endDateTime,
                                  imageUrl: imageUrl,
                                  status: status,
                                  additionalInfo: additionalInfo,
                                  ownerUserId: ownerUserId,
                                  startLocation: startLocation,
                                  endLocation: endLocation)

        let (hasAddedTransport, errorMessage) = await planService.addPlan(plan: transport)

        guard hasAddedTransport, errorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }
}
