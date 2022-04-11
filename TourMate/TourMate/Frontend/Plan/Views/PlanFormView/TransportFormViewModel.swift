//
//  TransportFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import Foundation

@MainActor
class TransportFormViewModel: PlanFormViewModel {
    @Published var startLocation: Location?
    @Published var endLocation: Location?

    // Adding Transport
    override init(lowerBoundDate: Date, upperBoundDate: Date, planService: PlanService, userService: UserService) {
        self.startLocation = nil
        self.endLocation = nil

        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    // Editing Transport
    init(lowerBoundDate: Date,
         upperBoundDate: Date,
         transport: Transport,
         planService: PlanService,
         userService: UserService) {
        self.startLocation = transport.startLocation
        self.endLocation = transport.endLocation

        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   plan: transport,
                   planService: planService,
                   userService: userService)
    }
}
