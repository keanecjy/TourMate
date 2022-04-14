//
//  SimplePlanView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimplePlanView<T: Plan>: View {
    @ObservedObject var planViewModel: PlanViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    private let viewModelFactory: ViewModelFactory

    init(planViewModel: PlanViewModel<T>) {
        self.viewModelFactory = ViewModelFactory()

        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)

        planViewModel.attachDelegate(delegate: commentsViewModel)
        planViewModel.attachDelegate(delegate: planUpvoteViewModel)

        self.planViewModel = planViewModel
    }

    var body: some View {
        HStack(spacing: 10.0) {
            Text(planViewModel.nameDisplay).font(.title3).bold()

            PlanStatusView(status: planViewModel.statusDisplay)
        }

        PlanUpvoteView(viewModel: planUpvoteViewModel)
            .allowsHitTesting(false)

        TimingView(startDate: planViewModel.startDateTimeDisplay,
                   endDate: planViewModel.endDateTimeDisplay)

        // Show location view

        InfoView(additionalInfo: planViewModel.additionalInfoDisplay)

        CommentsView(viewModel: commentsViewModel)

    }
}
