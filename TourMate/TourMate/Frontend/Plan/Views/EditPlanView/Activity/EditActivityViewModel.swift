//
//  EditActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class EditActivityViewModel: EditPlanViewModel<Activity> {
    @Published var location: Location?

    init(activity: Activity,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        self.location = activity.location

        super.init(plan: activity,
                   lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   planService: planService,
                   userService: userService)
    }

    override func updatePlan() async {
        let updatedActivity = Activity(plan: getPlanWithUpdatedFields(),
                                       location: location)

        await updatePlan(updatedActivity)
    }
}
