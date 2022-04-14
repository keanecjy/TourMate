//
//  AddActivityViewModel.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

@MainActor
class AddActivityViewModel: AddPlanViewModel<Activity> {
    @Published var location: Location

    override init(trip: Trip, planService: PlanService, userService: UserService) {
        self.location = Location()

        super.init(trip: trip,
                   planService: planService,
                   userService: userService)
    }

    override func addPlan() async {
        let activity = Activity(plan: await getPlanForAdding(),
                                location: location)

        await addPlan(activity)
    }
}
