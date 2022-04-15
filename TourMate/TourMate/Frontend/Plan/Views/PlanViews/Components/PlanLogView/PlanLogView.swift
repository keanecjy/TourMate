//
//  PlanLogView.swift
//  TourMate
//
//  Created by Terence Ho on 15/4/22.
//

import SwiftUI

struct PlanLogView<T: Plan>: View {

    private let viewModelFactory: ViewModelFactory
    private let viewFactory: ViewFactory

    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    @ObservedObject var commentsViewModel: CommentsViewModel
    @ObservedObject var planUpvoteViewModel: PlanUpvoteViewModel
    let addCommentViewModel: AddCommentViewModel

    init(planDisplayViewModel: PlanDisplayViewModel<T>,
         commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {

        self.viewModelFactory = ViewModelFactory()
        self.viewFactory = ViewFactory()

        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.addCommentViewModel = viewModelFactory.getAddCommentViewModel(commentsViewModel: commentsViewModel)
    }

    var body: some View {
        VStack(spacing: 15.0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20.0) {
                    ForEach(planDisplayViewModel.allVersionedPlansSortedDesc, id: \.versionNumber) { versionedPlan in

                        VStack(alignment: .leading, spacing: 10.0) { // Each Version's section

                            // Plan Version Header
                            viewFactory.getPlanVersionView(planDisplayViewModel: planDisplayViewModel,
                                                           plan: versionedPlan)

                            // Likes
                            viewFactory.getUpvotedUsersView(planUpvoteViewModel: planUpvoteViewModel,
                                                            version: versionedPlan.versionNumber)

                            // Comments
                            viewFactory.getComments(commentsViewModel: commentsViewModel,
                                                    version: versionedPlan.versionNumber)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Push all items to leading
            }
            .frame(height: 500.0, alignment: .leading) // push VStack to leading

            if commentsViewModel.allowUserInteraction {
                AddCommentView(viewModel: addCommentViewModel)
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20.0)
        .task {
            commentsViewModel.attachDelegate(delegate: addCommentViewModel)
            await commentsViewModel.fetchCommentsAndListen()
        }
        .onDisappear {
            commentsViewModel.detachDelegates()
            commentsViewModel.detachListener()
        }
    }
}

// struct PlanLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogView()
//    }
// }
