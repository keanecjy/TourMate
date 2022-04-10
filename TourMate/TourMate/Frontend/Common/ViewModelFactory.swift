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
    @Injected(\.locationService) var locationService: LocationService

    // Trips
    func getTripsViewModel() -> TripsViewModel {
        TripsViewModel(tripService: tripService.copy())
    }

    // Trip
    func getTripViewModel(trip: Trip) -> TripViewModel {
        TripViewModel(trip: trip, tripService: tripService.copy(), userService: userService)
    }

    func copyTripViewModel(tripViewModel: TripViewModel) -> TripViewModel {
        TripViewModel(trip: tripViewModel.trip, tripService: tripService.copy(), userService: userService)
    }

    // Add Trip
    func getAddTripViewModel() -> AddTripViewModel {
        AddTripViewModel(tripService: tripService.copy(), userService: userService)
    }

    // Edit Trip
    func getEditTripViewModel(tripViewModel: TripViewModel) -> EditTripViewModel {
        let trip = tripViewModel.trip
        return EditTripViewModel(trip: trip, tripService: tripService.copy(), userService: userService)
    }

    // Plans
    func getPlansViewModel(tripViewModel: TripViewModel) -> PlansViewModel {
        let tripId = tripViewModel.tripId
        let tripStartDateTime = tripViewModel.startDateTime
        let tripEndDateTime = tripViewModel.endDateTime

        return PlansViewModel(tripId: tripId,
                              tripStartDateTime: tripStartDateTime,
                              tripEndDateTime: tripEndDateTime,
                              planService: planService.copy())
    }

    // Plan
    func getPlanViewModel(plan: Plan, tripViewModel: TripViewModel) -> PlanViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return PlanViewModel(plan: plan,
                             lowerBoundDate: lowerBoundDate,
                             upperBoundDate: upperBoundDate,
                             planService: planService.copy(), userService: userService)
    }

    // Add Plan
    func getAddPlanViewModel(tripViewModel: TripViewModel) -> AddPlanViewModel {
        AddPlanViewModel(trip: tripViewModel.trip, planService: planService.copy(), userService: userService)
    }

    // Edit Plan
    func getEditPlanViewModel(planViewModel: PlanViewModel) -> EditPlanViewModel {
        let plan = planViewModel.plan
        let lowerBoundDate = planViewModel.lowerBoundDate
        let upperBoundDate = planViewModel.upperBoundDate

        return EditPlanViewModel(plan: plan,
                                 lowerBoundDate: lowerBoundDate,
                                 upperBoundDate: upperBoundDate,
                                 planService: planService.copy(), userService: userService)
    }

    // PlanView - PlanUpvotes
    func getPlanUpvoteViewModel(planViewModel: PlanViewModel) -> PlanUpvoteViewModel {
        getPlanUpvoteViewModel(plan: planViewModel.plan)
    }

    // PlansView - PlanUpvotes
    func getPlanUpvoteViewModel(plan: Plan) -> PlanUpvoteViewModel {
        PlanUpvoteViewModel(planId: plan.id, planVersionNumber: plan.versionNumber,
                            userService: userService, planUpvoteService: planUpvoteService.copy())
    }

    // Comments
    func getCommentsViewModel(planViewModel: PlanViewModel) -> CommentsViewModel {
        CommentsViewModel(planId: planViewModel.planId, commentService: commentService.copy(), userService: userService)
    }

    // Search
    func getSearchViewModel() -> SearchViewModel {
        SearchViewModel(locationService: locationService)
    }
}
