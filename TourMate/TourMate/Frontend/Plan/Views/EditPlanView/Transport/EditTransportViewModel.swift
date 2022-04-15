//
//  EditTransportViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class EditTransportViewModel: EditPlanViewModel<Transport> {
    @Published var startLocation: Location
    @Published var endLocation: Location

    init(transport: Transport,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        self.startLocation = transport.startLocation
        self.endLocation = transport.endLocation

        super.init(plan: transport,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    override func updatePlan() async {
        let updatedTransport = Transport(plan: getPlanWithUpdatedFields(),
                                         startLocation: startLocation,
                                         endLocation: endLocation)

        await updatePlan(updatedTransport)
    }

    override func getTripLocation() -> Location {
        if startLocation.isPresent() {
            return startLocation
        } else {
            return endLocation
        }
    }
}
