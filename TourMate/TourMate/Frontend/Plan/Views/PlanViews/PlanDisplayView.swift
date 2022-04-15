//
//  PlanDisplayView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct PlanDisplayView<T: Plan, Content: View>: View {

    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    private let content: Content

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel, content: Content) {
        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.content = content
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30.0) {
                PlanHeaderView(
                    planStatus: planDisplayViewModel.statusDisplay,
                    planOwner: planDisplayViewModel.planOwner,
                    creationDateDisplay: planDisplayViewModel.creationDateDisplay,
                    lastModifier: planDisplayViewModel.planLastModifier,
                    lastModifiedDateDisplay: planDisplayViewModel.lastModifiedDateDisplay,
                    versionNumberDisplay: planDisplayViewModel.versionNumberDisplay) {
                        Text(planDisplayViewModel.nameDisplay)
                            .bold()
                            .prefixedWithIcon(named: planDisplayViewModel.prefixedNameDisplay)
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: planDisplayViewModel.startDateTimeDisplay,
                           endDate: planDisplayViewModel.endDateTimeDisplay)

                content

                InfoView(additionalInfo: planDisplayViewModel.additionalInfoDisplay)

                CommentsView(viewModel: commentsViewModel)
            }
        }
    }
}
