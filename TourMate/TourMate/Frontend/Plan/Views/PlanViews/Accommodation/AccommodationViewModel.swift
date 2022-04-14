//
//  AccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import Foundation

@MainActor
class AccommodationViewModel: PlanViewModel<Accommodation> {
    init(accommodation: Accommodation,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planService: PlanService,
         userService: UserService) {
        super.init(plan: accommodation,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    init(accommodation: Accommodation,
         versionedAccommodations: [Accommodation],
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planOwner: User,
         planLastModifier: User,
         planService: PlanService,
         userService: UserService) {
        super.init(plan: accommodation,
                   allVersionedPlans: versionedAccommodations,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planOwner: planOwner, planLastModifier: planLastModifier,
                   planService: planService, userService: userService)
    }

    override var prefixedNameDisplay: String {
        "bed.double.circle.fill"
    }

    var location: Location? {
        plan.location
    }

}
