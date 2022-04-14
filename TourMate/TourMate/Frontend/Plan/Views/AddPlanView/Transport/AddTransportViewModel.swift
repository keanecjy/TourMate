//
//  AddTransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class AddTransportViewModel: AddPlanViewModel<Transport> {
    @Published var startLocation: Location?
    @Published var endLocation: Location?

    override init(trip: Trip, planService: PlanService, userService: UserService) {
        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    override func addPlan() async {
        let transport = Transport(plan: await getPlanForAdding(),
                                  startLocation: startLocation,
                                  endLocation: endLocation)

        await addPlan(transport)
    }
}
