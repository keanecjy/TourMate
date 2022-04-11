//
//  ActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class ActivityViewModel: PlanViewModel {
    @Published var activity: Activity

    init(activity: Activity,
         lowerBoundDate: DateTime,
         upperBoundDate: DateTime,
         planService: PlanService,
         userService: UserService) {
        self.activity = activity
        super.init(plan: activity,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    var location: Location? {
        activity.location
    }

    override func loadLatestVersionedPlan(_ plans: [Plan]) {
        guard var latestPlan = plans.first else {
            handleDeletion()
            return
        }

        for plan in plans where plan.versionNumber > latestPlan.versionNumber {
            latestPlan = plan
        }

        if let activity = latestPlan as? Activity {
            self.activity = activity
        }

        self.plan = latestPlan
        self.allVersionedPlans = plans
    }
}
