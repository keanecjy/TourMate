//
//  TransportFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import Foundation

@MainActor
class TransportFormViewModel: PlanFormViewModel<Transport> {
    @Published var startLocation: Location
    @Published var endLocation: Location

    // Adding Transport
    override init(trip: Trip,
                  planService: PlanService,
                  userService: UserService) {
        self.startLocation = Location()
        self.endLocation = Location()

        super.init(trip: trip,
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
