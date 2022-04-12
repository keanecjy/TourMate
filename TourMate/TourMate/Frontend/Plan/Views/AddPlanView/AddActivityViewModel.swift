//
//  AddActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class AddActivityViewModel: ActivityFormViewModel {

    override init(trip: Trip, planService: PlanService, userService: UserService) {
        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    func addActivity() async {
        let activity = Activity(plan: await getPlanForAdding(),
                                location: location)

        await addPlan(activity)
    }
}
