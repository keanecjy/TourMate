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
        let tripId = tripViewModel.trip.id
        let tripStartDateTime = tripViewModel.trip.startDateTime
        let tripEndDateTime = tripViewModel.trip.endDateTime

        return PlansViewModel(tripId: tripId,
                              tripStartDateTime: tripStartDateTime,
                              tripEndDateTime: tripEndDateTime)
    }

    // Plan
    static func getPlanViewModel(plan: Plan, plansViewModel: PlansViewModel) -> PlanViewModel {
        let lowerBoundDate = plansViewModel.tripStartDateTime
        let upperBoundDate = plansViewModel.tripEndDateTime

        return PlanViewModel(plan: plan,
                             lowerBoundDate: lowerBoundDate,
                             upperBoundDate: upperBoundDate)
    }

    static func getPlanViewModel(plan: Plan, tripViewModel: TripViewModel) -> PlanViewModel {
        let lowerBoundDate = tripViewModel.trip.startDateTime
        let upperBoundDate = tripViewModel.trip.endDateTime

        return PlanViewModel(plan: plan,
                             lowerBoundDate: lowerBoundDate,
                             upperBoundDate: upperBoundDate)
    }

    // Add Plan
    static func getAddPlanViewModel(tripViewModel: TripViewModel) -> AddPlanViewModel {
        AddPlanViewModel(trip: tripViewModel.trip)
    }

    // Edit Plan
    static func getEditPlanViewModel(planViewModel: PlanViewModel) -> EditPlanViewModel {
        let plan = planViewModel.plan
        let lowerBoundDate = planViewModel.lowerBoundDate
        let upperBoundDate = planViewModel.upperBoundDate

        return EditPlanViewModel(plan: plan,
                                 lowerBoundDate: lowerBoundDate,
                                 upperBoundDate: upperBoundDate)
    }

    // Comments
    static func getCommentsViewModel(planViewModel: PlanViewModel) -> CommentsViewModel {
        CommentsViewModel(planId: planViewModel.plan.id)
    }
}
