//
//  ActivityFormViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 11/4/22.
//

import Foundation

@MainActor
class ActivityFormViewModel: PlanFormViewModel<Activity> {
    @Published var location: Location

    // Adding Activity
    override init(trip: Trip,
                  planService: PlanService,
                  userService: UserService) {
        self.location = Location()

        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    // Editing Activity
    init(lowerBoundDate: Date,
         upperBoundDate: Date,
         activity: Activity,
         planService: PlanService,
         userService: UserService) {
        self.location = activity.location

        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   plan: activity,
                   planService: planService,
                   userService: userService)
    }
}
