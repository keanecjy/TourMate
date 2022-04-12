//
//  EditAccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import Foundation

@MainActor
class EditAccommodationViewModel: EditPlanViewModel<Accommodation> {
    @Published var location: Location?

    init(accommodation: Accommodation,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        self.location = accommodation.location

        super.init(plan: accommodation,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    override func updatePlan() async {
        let updatedAccommodation = Accommodation(plan: getPlanWithUpdatedFields(),
                                                 location: location)

        await updatePlan(updatedAccommodation)
    }
}
