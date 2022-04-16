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
    @StateObject var planUpvoteViewModel: PlanUpvoteViewModel

    private let content: Content

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel, @ViewBuilder content: () -> Content) {
        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self._planUpvoteViewModel = StateObject(wrappedValue: planUpvoteViewModel)
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30.0) {
                SimplePlanHeader(name: planDisplayViewModel.nameDisplay, status: planDisplayViewModel.statusDisplay)

                PlanUpvoteView(viewModel: planUpvoteViewModel)
                    .disabled(false)

                TimingView(startDate: planDisplayViewModel.startDateTimeDisplay,
                           endDate: planDisplayViewModel.endDateTimeDisplay,
                           displayIcon: false)

                content

                AdditionalInfoView(additionalInfo: planDisplayViewModel.additionalInfoDisplay)

                CommentsView(viewModel: commentsViewModel, versionNumber: planDisplayViewModel.versionNumber)

                Spacer()
            }
        }
    }
}
