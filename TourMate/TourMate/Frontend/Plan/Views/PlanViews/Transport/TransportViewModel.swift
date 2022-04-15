//
//  TransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

class TransportViewModel: PlanViewModel<Transport> {
    init(transport: Transport,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planService: PlanService,
         userService: UserService) {
        super.init(plan: transport,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    init(transport: Transport,
         versionedTransports: [Transport],
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planOwner: User,
         planLastModifier: User,
         planService: PlanService,
         userService: UserService) {
        super.init(plan: transport,
                   allVersionedPlans: versionedTransports,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planOwner: planOwner, planLastModifier: planLastModifier,
                   planService: planService, userService: userService)
    }

    override var prefixedNameDisplay: String {
        "car.circle.fill"
    }

    var startLocation: Location? {
        plan.startLocation
    }

    var endLocation: Location? {
        plan.endLocation
    }

}
