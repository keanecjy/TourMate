//
//  AddAccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import Foundation

@MainActor
class AddAccommodationViewModel: AccommodationFormViewModel {

    override init(trip: Trip, planService: PlanService, userService: UserService) {
        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    func addAccommodation() async {
        let accommodation = Accommodation(plan: await getPlanForAdding(),
                                          location: location)

        await addPlan(accommodation)
    }
}
