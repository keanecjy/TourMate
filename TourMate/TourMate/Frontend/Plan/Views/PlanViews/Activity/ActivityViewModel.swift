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

    init(activity: Activity,
         versionedActivities: [Activity],
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planOwner: User,
         planLastModifier: User,
         planService: PlanService,
         userService: UserService) {
        super.init(plan: activity,
                   allVersionedPlans: versionedActivities,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planOwner: planOwner, planLastModifier: planLastModifier,
                   planService: planService, userService: userService)
    }

    override var prefixedNameDisplay: String {
        "theatermasks.circle.fill"
    }

    var location: Location? {
        plan.location
    }

}
