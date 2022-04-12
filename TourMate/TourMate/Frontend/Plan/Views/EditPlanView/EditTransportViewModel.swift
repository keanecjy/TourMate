//
//  EditTransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

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
        let updatedTransport = Transport(plan: getPlanWithUpdatedFields(),
                                         startLocation: startLocation,
                                         endLocation: endLocation)

        await updatePlan(updatedTransport)
    }
}
