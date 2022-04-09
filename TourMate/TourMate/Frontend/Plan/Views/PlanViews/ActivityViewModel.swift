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

    override func updatePublishedProperties(plan: Plan) async {
        if let plan = plan as? Activity {
            print("[ActivityViewModel] Publishing activity \(plan) changes")
            self.activity = plan
            self.plan = plan
        } else {
            print("[ActivityViewModel] Failed to update activity, shall update plan instead")
            await super.updatePublishedProperties(plan: plan)
        }
    }
}
