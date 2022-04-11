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

    override func loadLatestVersionedPlan(_ plans: [Plan]) {
        guard var latestPlan = plans.first else {
            handleDeletion()
            return
        }

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        if let transport = latestPlan as? Transport {
            self.transport = transport
        }

        self.plan = latestPlan
        self.allPlans = plans
    }
}
