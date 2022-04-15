//
//  AddAccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import Foundation

@MainActor
class AddAccommodationViewModel: AddPlanViewModel<Accommodation> {
    @Published var location: Location

    override init(trip: Trip, planService: PlanService, userService: UserService) {
        self.location = Location()

        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    override func addPlan() async {
        let accommodation = Accommodation(plan: await getPlanForAdding(),
                                          location: location)

        await addPlan(accommodation)
    }
}
