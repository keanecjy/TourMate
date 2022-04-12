//
//  AddTransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class AddTransportViewModel: TransportFormViewModel {

    override init(trip: Trip, planService: PlanService, userService: UserService) {
        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    func addTransport() async {
        let transport = Transport(plan: await getPlanForAdding(),
                                  startLocation: startLocation,
                                  endLocation: endLocation)

        await addPlan(transport)
    }
}
