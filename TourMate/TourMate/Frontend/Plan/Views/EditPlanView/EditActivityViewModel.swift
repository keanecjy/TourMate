//
//  EditActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class EditActivityViewModel: ActivityFormViewModel {

    init(activity: Activity,
         lowerBoundDate: Date,
         upperBoundDate: Date,
         planService: PlanService,
         userService: UserService) {
        super.init(lowerBoundDate: lowerBoundDate,
                   upperBoundDate: upperBoundDate,
                   activity: activity,
                   planService: planService,
                   userService: userService)
    }

    func updateActivity() async {
        let updatedActivity = Activity(plan: getPlanWithUpdatedFields(),
                                       location: location)

        await updatePlan(updatedActivity)
    }
}
