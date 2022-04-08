//
//  ViewModelFactory.swift
//  TourMate
//
//  Created by Terence Ho on 2/4/22.
//

import Foundation

@MainActor
struct ViewModelFactory {

    // Trips
    static func getTripsViewModel() -> TripsViewModel {
        TripsViewModel()
    }

    // Trip
    static func getTripViewModel(trip: Trip) -> TripViewModel {
        TripViewModel(trip: trip)
    }

    static func copyTripViewModel(tripViewModel: TripViewModel) -> TripViewModel {
        TripViewModel(trip: tripViewModel.trip)
    }

    // Add Trip
    static func getAddTripViewModel() -> AddTripViewModel {
        AddTripViewModel()
    }

    // Edit Trip
    static func getEditTripViewModel(tripViewModel: TripViewModel) -> EditTripViewModel {
        let trip = tripViewModel.trip
        return EditTripViewModel(trip: trip)
    }

    // Plans
    static func getPlansViewModel(tripViewModel: TripViewModel) -> PlansViewModel {
        let tripId = tripViewModel.tripId
        let tripStartDateTime = tripViewModel.startDateTime
        let tripEndDateTime = tripViewModel.endDateTime

        return PlansViewModel(tripId: tripId,
                              tripStartDateTime: tripStartDateTime,
                              tripEndDateTime: tripEndDateTime)
    }

    // Plan
    static func getPlanViewModel(plan: Plan, tripViewModel: TripViewModel) -> PlanViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return PlanViewModel(plan: plan,
                             lowerBoundDate: lowerBoundDate,
                             upperBoundDate: upperBoundDate)
    }

    static func getActivityViewModel(activity: Activity, tripViewModel: TripViewModel) -> ActivityViewModel {
        let lowerBoundDate = tripViewModel.startDateTime
        let upperBoundDate = tripViewModel.endDateTime

        return ActivityViewModel(activity: activity, lowerBoundDate: lowerBoundDate, upperBoundDate: upperBoundDate)
    }

    // Add Plan
//    static func getAddPlanViewModel(tripViewModel: TripViewModel) -> AddPlanViewModel {
//        AddPlanViewModel(trip: tripViewModel.trip)
//    }

    // Edit Plan
    static func getEditPlanViewModel(planViewModel: PlanViewModel) -> EditPlanViewModel {
        let plan = planViewModel.plan
        let lowerBoundDate = planViewModel.lowerBoundDate
        let upperBoundDate = planViewModel.upperBoundDate

        return EditPlanViewModel(plan: plan,
                                 lowerBoundDate: lowerBoundDate,
                                 upperBoundDate: upperBoundDate)
    }

    static func getEditActivityViewModel(planViewModel: PlanViewModel) -> EditActivityViewModel {
        let plan = planViewModel.plan
        let lowerBoundDate = planViewModel.lowerBoundDate
        let upperBoundDate = planViewModel.upperBoundDate

        return EditActivityViewModel(plan: plan,
                                     lowerBoundDate: lowerBoundDate,
                                     upperBoundDate: upperBoundDate)
    }

    // PlanView - PlanUpvotes
    static func getPlanUpvoteViewModel(planViewModel: PlanViewModel) -> PlanUpvoteViewModel {
        getPlanUpvoteViewModel(plan: planViewModel.plan)
    }

    // PlansView - PlanUpvotes
    static func getPlanUpvoteViewModel(plan: Plan) -> PlanUpvoteViewModel {
        PlanUpvoteViewModel(planId: plan.id)
    }

    // Comments
    static func getCommentsViewModel(planViewModel: PlanViewModel) -> CommentsViewModel {
        CommentsViewModel(planId: planViewModel.planId)
    }
}
