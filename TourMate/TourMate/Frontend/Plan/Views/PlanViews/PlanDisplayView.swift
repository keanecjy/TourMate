//
//  PlanDisplayView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct PlanDisplayView<T: Plan, Content: View>: View {

    let planViewModel: PlanDisplayViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    private let content: Content

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel, content: Content) {
        self.planViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            PlanHeaderView(
                planStatus: planViewModel.statusDisplay,
                planOwner: planViewModel.planOwner,
                creationDateDisplay: planViewModel.creationDateDisplay,
                lastModifier: planViewModel.planLastModifier,
                lastModifiedDateDisplay: planViewModel.lastModifiedDateDisplay,
                versionNumberDisplay: planViewModel.versionNumberDisplay) {
                    Text(planViewModel.nameDisplay)
                        .bold()
                        .prefixedWithIcon(named: planViewModel.prefixedNameDisplay)
            }

            PlanUpvoteView(viewModel: planUpvoteViewModel)

            TimingView(startDate: planViewModel.startDateTimeDisplay,
                       endDate: planViewModel.endDateTimeDisplay)

            content

            InfoView(additionalInfo: planViewModel.additionalInfoDisplay)

            CommentsView(viewModel: commentsViewModel)

            Spacer() // Push everything to the top
        }
    }
}
