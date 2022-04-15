//
//  PlanLogView.swift
//  TourMate
//
//  Created by Terence Ho on 15/4/22.
//

import SwiftUI

struct PlanLogView<T: Plan>: View {

    private let viewModelFactory: ViewModelFactory
    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    @ObservedObject var commentsViewModel: CommentsViewModel
    @ObservedObject var planUpvoteViewModel: PlanUpvoteViewModel
    let addCommentViewModel: AddCommentViewModel

    init(planDisplayViewModel: PlanDisplayViewModel<T>,
         commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {

        self.viewModelFactory = ViewModelFactory()
        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.addCommentViewModel = viewModelFactory.getAddCommentViewModel(commentsViewModel: commentsViewModel)
    }

    func getPlanVersionView(plan: T) -> some View {
        let action = plan.versionNumber == 1 ? "created" : "updated"
        return HStack {
            Spacer()
            Text("Plan version \(plan.versionNumber) \(action) by <User.name>")
                .bold()
            Spacer()
        }
    }

    @ViewBuilder
    func getUpvotedUsersView(version: Int) -> some View {
        let upvotedUsers = planUpvoteViewModel.getUpvotedUsersForVersion(version: version)

        if !upvotedUsers.isEmpty {
            let upvotedUsersText = upvotedUsers.map({ $0.name }).joined(separator: ", ")
            let displayText = upvotedUsersText + " liked this version :)"

            HStack {
                Spacer()

                Text(displayText)

                Spacer()
            }
        }
    }

    func getComments(version: Int) -> some View {
        let commentOwnerPairs = commentsViewModel.getCommentsForVersion(version: version)

        return ForEach(commentOwnerPairs, id: \.0.id) { comment, user in
            CommentView(viewModel: commentsViewModel, comment: comment, user: user)
        }
    }

    var body: some View {
        VStack(spacing: 15.0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20.0) {
                    ForEach(planDisplayViewModel.allVersionedPlansSorted, id: \.versionNumber) { versionedPlan in

                        VStack(alignment: .leading, spacing: 10.0) { // Each Version's section

                            // Plan Version Header
                            getPlanVersionView(plan: versionedPlan)

                            // Likes
                            getUpvotedUsersView(version: versionedPlan.versionNumber)

                            // Comments
                            getComments(version: versionedPlan.versionNumber)
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
