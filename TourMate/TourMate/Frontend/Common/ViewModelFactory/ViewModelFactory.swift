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

    func getActivityViewModel(activity: Activity, tripViewModel: TripViewModel) -> ActivityViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return ActivityViewModel(activity: activity,
                                 lowerBoundDate: lowerBoundDate,
                                 upperBoundDate: upperBoundDate,
                                 planService: planService.copy(), userService: userService)
    }

    func getAccommodationViewModel(accommodation: Accommodation,
                                   tripViewModel: TripViewModel) -> AccommodationViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return AccommodationViewModel(
            accommodation: accommodation,
            lowerBoundDate: lowerBoundDate,
            upperBoundDate: upperBoundDate,
            planService: planService.copy(),
            userService: userService)
    }

    func getTransportViewModel(transport: Transport, tripViewModel: TripViewModel) -> TransportViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return TransportViewModel(
            transport: transport,
            lowerBoundDate: lowerBoundDate,
            upperBoundDate: upperBoundDate,
            planService: planService.copy(),
            userService: userService)
    }

    func copyPlanViewModel<T: Plan>(_ planViewModel: PlanViewModel<T>) -> PlanViewModel<T> {
        PlanViewModel(plan: planViewModel.plan,
                      allVersionedPlans: planViewModel.allVersionedPlans,
                      lowerBoundDate: planViewModel.lowerBoundDate,
                      upperBoundDate: planViewModel.lowerBoundDate,
                      planOwner: planViewModel.planOwner,
                      planLastModifier: planViewModel.planLastModifier,
                      planService: planService.copy(),
                      userService: userService)
    }

    // Add Plan
    func getAddActivityViewModel(trip: Trip) -> AddActivityViewModel {
        AddActivityViewModel(trip: trip, planService: planService.copy(), userService: userService)
    }

    func getAddAccommodationViewModel(trip: Trip) -> AddAccommodationViewModel {
        AddAccommodationViewModel(trip: trip, planService: planService.copy(), userService: userService)
    }

    func getAddTransportViewModel(trip: Trip) -> AddTransportViewModel {
        AddTransportViewModel(trip: trip, planService: planService.copy(), userService: userService)
    }

    // Edit Plan
    func getEditActivityViewModel(activity: Activity,
                                  lowerBoundDate: Date,
                                  upperBoundDate: Date) -> EditActivityViewModel {
        EditActivityViewModel(
            activity: activity,
            lowerBoundDate: lowerBoundDate,
            upperBoundDate: upperBoundDate,
            planService: planService.copy(),
            userService: userService)
    }

    func getEditAccommodationViewModel(accommodation: Accommodation,
                                       lowerBoundDate: Date,
                                       upperBoundDate: Date) -> EditAccommodationViewModel {
        EditAccommodationViewModel(
            accommodation: accommodation,
            lowerBoundDate: lowerBoundDate,
            upperBoundDate: upperBoundDate,
            planService: planService.copy(),
            userService: userService)
    }

    func getEditTransportViewModel(transport: Transport,
                                   lowerBoundDate: Date,
                                   upperBoundDate: Date) -> EditTransportViewModel {
        EditTransportViewModel(
            transport: transport,
            lowerBoundDate: lowerBoundDate,
            upperBoundDate: upperBoundDate,
            planService: planService.copy(),
            userService: userService)
    }

    // PlanView - PlanUpvotes
    func getPlanUpvoteViewModel<T: Plan>(planViewModel: PlanViewModel<T>) -> PlanUpvoteViewModel {
        getPlanUpvoteViewModel(plan: planViewModel.plan)
    }

    // PlansView - PlanUpvotes
    func getPlanUpvoteViewModel(plan: Plan) -> PlanUpvoteViewModel {
        PlanUpvoteViewModel(planId: plan.id, planVersionNumber: plan.versionNumber,
                            userService: userService, planUpvoteService: planUpvoteService.copy())
    }

    // Search
    func getSearchViewModel() -> SearchViewModel {
        SearchViewModel(locationService: locationService)
    }
}
