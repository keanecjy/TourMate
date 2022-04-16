//
//  PlanLogDetailView.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct PlanLogListView<T: Plan>: View {

    private let viewFactory: ViewFactory

    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    @ObservedObject var commentsViewModel: CommentsViewModel
    @ObservedObject var planUpvoteViewModel: PlanUpvoteViewModel

    init(planDisplayViewModel: PlanDisplayViewModel<T>,
         commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {

        self.viewFactory = ViewFactory()

        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
    }

    var body: some View {
        ForEach(planDisplayViewModel.allVersionedPlansSortedDesc, id: \.versionNumber) { versionedPlan in
            VStack(alignment: .leading, spacing: 10.0) { // Each Version's section

                // Plan Version Header
                viewFactory.getPlanVersionView(planDisplayViewModel: planDisplayViewModel,
                                               plan: versionedPlan)

                // Likes
                viewFactory.getUpvotedUsersView(planUpvoteViewModel: planUpvoteViewModel,
                                                version: versionedPlan.versionNumber)

                // Comments
                CommentListView(viewModel: commentsViewModel,
                                forVersion: versionedPlan.versionNumber)
            }
        }
    }
}

// struct PlanLogDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogListView()
//    }
// }
