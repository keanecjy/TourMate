//
//  ViewModelFactory.swift
//  TourMate
//
//  Created by Terence Ho on 2/4/22.
//

import Foundation

@MainActor
struct ViewModelFactory {

    @Injected(\.tripService) var tripService: TripService
    @Injected(\.userService) var userService: UserService
    @Injected(\.planService) var planService: PlanService
    @Injected(\.commentService) var commentService: CommentService
    @Injected(\.planUpvoteService) var planUpvoteService: PlanUpvoteService

    // Trips
    func getTripsViewModel() -> TripsViewModel {
        TripsViewModel(tripService: tripService)
    }

    // Trip
    func getTripViewModel(trip: Trip) -> TripViewModel {
        TripViewModel(trip: trip, tripService: tripService, userService: userService)
    }

    func copyTripViewModel(tripViewModel: TripViewModel) -> TripViewModel {
        TripViewModel(trip: tripViewModel.trip, tripService: tripService, userService: userService)
    }

    // Add Trip
    func getAddTripViewModel() -> AddTripViewModel {
        AddTripViewModel(tripService: tripService, userService: userService)
    }

    // Edit Trip
    func getEditTripViewModel(tripViewModel: TripViewModel) -> EditTripViewModel {
        let trip = tripViewModel.trip
        return EditTripViewModel(trip: trip, tripService: tripService, userService: userService)
    }

    // Plans
    func getPlansViewModel(tripViewModel: TripViewModel) -> PlansViewModel {
        let tripId = tripViewModel.tripId
        let tripStartDateTime = tripViewModel.startDateTime
        let tripEndDateTime = tripViewModel.endDateTime

        return PlansViewModel(tripId: tripId,
                              tripStartDateTime: tripStartDateTime,
                              tripEndDateTime: tripEndDateTime,
                              planService: planService)
    }

    // Plan
    func getPlanViewModel(plan: Plan, tripViewModel: TripViewModel) -> PlanViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return PlanViewModel(plan: plan,
                             lowerBoundDate: lowerBoundDate,
                             upperBoundDate: upperBoundDate,
        planService: planService, userService: userService)
    }

    // Add Plan
    func getAddPlanViewModel(tripViewModel: TripViewModel) -> AddPlanViewModel {
        AddPlanViewModel(trip: tripViewModel.trip, planService: planService, userService: userService)
    }

    // Edit Plan
    func getEditPlanViewModel(planViewModel: PlanViewModel) -> EditPlanViewModel {
        let plan = planViewModel.plan
        let lowerBoundDate = planViewModel.lowerBoundDate
        let upperBoundDate = planViewModel.upperBoundDate

        return EditPlanViewModel(plan: plan,
                                 lowerBoundDate: lowerBoundDate,
                                 upperBoundDate: upperBoundDate,
        planService: planService, userService: userService)
    }

    // PlanView - PlanUpvotes
    func getPlanUpvoteViewModel(planViewModel: PlanViewModel) -> PlanUpvoteViewModel {
        getPlanUpvoteViewModel(plan: planViewModel.plan)
    }

    // PlansView - PlanUpvotes
    func getPlanUpvoteViewModel(plan: Plan) -> PlanUpvoteViewModel {
        PlanUpvoteViewModel(planId: plan.id, userService: userService, planUpvoteService: planUpvoteService)
    }

    // Comments
    func getCommentsViewModel(planViewModel: PlanViewModel) -> CommentsViewModel {
        CommentsViewModel(planId: planViewModel.planId, commentService: commentService, userService: userService)
    }
}
