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

    override func updatePublishedProperties(plan: Plan) async {
        if let plan = plan as? Accommodation {
            print("[AccommodationViewModel] Publishing accommodation \(plan) changes")
            self.accommodation = plan
            self.plan = plan
        } else {
            print("[AccommodationViewModel] Failed to update accommodation, shall update plan instead")
            await super.updatePublishedProperties(plan: plan)
        }
    }
}
