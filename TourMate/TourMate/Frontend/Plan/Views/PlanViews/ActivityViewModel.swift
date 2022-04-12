//
//  ActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class ActivityViewModel: PlanViewModel<Activity> {
    init(activity: Activity,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planService: PlanService,
         userService: UserService) {
        super.init(plan: activity,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    override var prefixedNameDisplay: String {
        "figure.walk.circle.fill"
    }

    var location: Location? {
        plan.location
    }

}
