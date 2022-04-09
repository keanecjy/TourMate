//
//  TransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

class TransportViewModel: PlanViewModel {
    @Published var transport: Transport

    init(transport: Transport,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planService: PlanService,
         userService: UserService) {
        self.transport = transport
        super.init(plan: transport,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    var startLocation: Location? {
        transport.startLocation
    }

    var endLocation: Location? {
        transport.endLocation
    }

    override func updatePublishedProperties(plan: Plan) async {
        if let plan = plan as? Transport {
            self.transport = plan
            self.plan = plan
        } else {
            await super.updatePublishedProperties(plan: plan)
        }
    }
}
