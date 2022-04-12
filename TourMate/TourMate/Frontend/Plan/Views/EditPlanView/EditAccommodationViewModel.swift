//
//  EditAccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class EditAccommodationViewModel: AccommodationFormViewModel {

    init(accommodation: Accommodation,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   accommodation: accommodation, planService: planService,
                   userService: userService)
    }

    func updateAccommodation() async {
        self.isLoading = true

        let updatedAccommodation = Accommodation(plan: getPlanWithUpdatedFields(),
                                                 location: location)

        await updatePlan(updatedAccommodation)
    }
}
