//
//  SimplePlanDisplayView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimplePlanDisplayView<T: Plan>: View {
    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {
        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
    }

    var body: some View {
        HStack(spacing: 10.0) {
            Text(planDisplayViewModel.nameDisplay).font(.title3).bold()

            PlanStatusView(status: planDisplayViewModel.statusDisplay)
        }

        PlanUpvoteView(viewModel: planUpvoteViewModel)
            .allowsHitTesting(false)

        TimingView(startDate: planDisplayViewModel.startDateTimeDisplay,
                   endDate: planDisplayViewModel.endDateTimeDisplay)

        // Show location view

        InfoView(additionalInfo: planDisplayViewModel.additionalInfoDisplay)

        SimpleCommentsView(viewModel: commentsViewModel)
            .disabled(false)

        Spacer()
    }
}
