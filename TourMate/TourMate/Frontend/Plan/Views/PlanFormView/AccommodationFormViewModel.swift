//
//  AccommodationFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import Foundation

@MainActor
class AccommodationFormViewModel: PlanFormViewModel {
    @Published var location: Location?

    // Adding Accommodation
    override init(lowerBoundDate: Date, upperBoundDate: Date, planService: PlanService, userService: UserService) {
        self.location = nil

        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    // Editing Accommodation
    init(lowerBoundDate: Date,
         upperBoundDate: Date,
         accommodation: Accommodation,
         planService: PlanService,
         userService: UserService) {
        self.location = accommodation.location

        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   plan: accommodation,
                   planService: planService,
                   userService: userService)
    }
}
