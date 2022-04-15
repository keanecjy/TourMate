//
//  SimplePlanDisplayView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimplePlanDisplayView<T: Plan, Content: View>: View {
    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    private let content: Content

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel, @ViewBuilder content: () -> Content) {
        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30.0) {
                HStack(spacing: 10.0) {
                    Text(planDisplayViewModel.nameDisplay).font(.title).bold()

                    PlanStatusView(status: planDisplayViewModel.statusDisplay)
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)
                    .allowsHitTesting(false)

                TimingView(startDate: planDisplayViewModel.startDateTimeDisplay,
                           endDate: planDisplayViewModel.endDateTimeDisplay,
                           displayIcon: false)

                content

                InfoView(additionalInfo: planDisplayViewModel.additionalInfoDisplay)

                CommentsView(viewModel: commentsViewModel)

                Spacer()
            }
        }
    }
}
