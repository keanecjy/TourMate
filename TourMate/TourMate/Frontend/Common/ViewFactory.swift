//
//  ViewFactory.swift
//  TourMate
//
//  Created by Keane Chan on 12/4/22.
//

import SwiftUI

@MainActor
struct ViewFactory {

    func getEditPlanView<T: Plan>(planViewModel: PlanViewModel<T>) -> some View {
        let viewModelFactory = ViewModelFactory()
        let lowerBoundDate = planViewModel.lowerBoundDate.date
        let upperBoundDate = planViewModel.upperBoundDate.date

        switch planViewModel.plan {
        case let activity as Activity:
            let activityViewModel = viewModelFactory.getEditActivityViewModel(activity: activity,
                                                                              lowerBoundDate: lowerBoundDate,
                                                                              upperBoundDate: upperBoundDate)
            return AnyView(EditActivityView(viewModel: activityViewModel))
        case let accommodation as Accommodation:
            let viewModel = viewModelFactory.getEditAccommodationViewModel(accommodation: accommodation,
                                                                           lowerBoundDate: lowerBoundDate,
                                                                           upperBoundDate: upperBoundDate)
            return AnyView(EditAccommodationView(viewModel: viewModel))
        case let transport as Transport:
            let viewModel = viewModelFactory.getEditTransportViewModel(transport: transport,
                                                                       lowerBoundDate: lowerBoundDate,
                                                                       upperBoundDate: upperBoundDate)
            return AnyView(EditTransportView(viewModel: viewModel))
        default:
            preconditionFailure("Plan don't exists")
        }
    }

    func getPlanView(plan: Plan, tripViewModel: TripViewModel) -> some View {
        let viewModelFactory = ViewModelFactory()

        switch plan {
        case let plan as Activity:
            let viewModel = viewModelFactory.getActivityViewModel(activity: plan,
                                                                  tripViewModel: tripViewModel)
            return AnyView(ActivityView(planViewModel: viewModel))
        case let plan as Accommodation:
            let viewModel = viewModelFactory.getAccommodationViewModel(accommodation: plan,
                                                                       tripViewModel: tripViewModel)
            return AnyView(AccommodationView(planViewModel: viewModel))
        case let plan as Transport:
            let viewModel = viewModelFactory.getTransportViewModel(transport: plan,
                                                                   tripViewModel: tripViewModel)
            return AnyView(TransportView(planViewModel: viewModel))
        default:
            preconditionFailure("Plan don't exists")
        }
    }

    func getSimplePlanDisplayView<T: Plan>(planViewModel: PlanViewModel<T>,
                                           commentsViewModel: CommentsViewModel,
                                           planUpvoteViewModel: PlanUpvoteViewModel) -> some View {
        let viewModelFactory = ViewModelFactory()

        switch planViewModel.plan {
        case is Activity:
            let viewModel = viewModelFactory
                .getActivityViewModel(planViewModel: planViewModel as! PlanViewModel<Activity>)
            return AnyView(SimpleActivityDisplayView(planViewModel: viewModel,
                                                     commentsViewModel: commentsViewModel,
                                                     planUpvoteViewModel: planUpvoteViewModel))
        case is Accommodation:
            let viewModel = viewModelFactory
                .getAccommodationViewModel(planViewModel: planViewModel as! PlanViewModel<Accommodation>)
            return AnyView(SimpleAccommodationDisplayView(planViewModel: viewModel,
                                                          commentsViewModel: commentsViewModel,
                                                          planUpvoteViewModel: planUpvoteViewModel))
        case is Transport:
            let viewModel = viewModelFactory
                .getTransportViewModel(planViewModel: planViewModel as! PlanViewModel<Transport>)
            return AnyView(SimpleTransportDisplayView(planViewModel: viewModel,
                                                      commentsViewModel: commentsViewModel,
                                                      planUpvoteViewModel: planUpvoteViewModel))
        default:
            preconditionFailure("Plan don't exists")
        }
    }
}
