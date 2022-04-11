//
//  AccommodationViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import Foundation

@MainActor
class AccommodationViewModel: PlanViewModel {
    @Published var accommodation: Accommodation

    init(accommodation: Accommodation,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planService: PlanService,
         userService: UserService) {
        self.accommodation = accommodation
        super.init(plan: accommodation,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    var location: Location? {
        accommodation.location
    }

    override func loadLatestVersionedPlan(_ plans: [Plan]) {
        guard var latestPlan = plans.first else {
            handleDeletion()
            return
        }

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        if let accommodation = latestPlan as? Accommodation {
            self.accommodation = accommodation
        }

        self.plan = latestPlan
        self.allVersionedPlans = plans
    }
}
