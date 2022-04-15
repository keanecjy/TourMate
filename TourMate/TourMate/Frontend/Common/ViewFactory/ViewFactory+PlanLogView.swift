//
//  ViewFactory+PlanLogView.swift
//  TourMate
//
//  Created by Terence Ho on 15/4/22.
//

import Foundation
import SwiftUI

// MARK: PlanLogView components
extension ViewFactory {

    func getPlanVersionView<T: Plan>(planDisplayViewModel: PlanDisplayViewModel<T>, plan: T) -> some View {
        let action = plan.versionNumber == 1 ? "created" : "updated"
        let username = planDisplayViewModel.getPlanModifier(version: plan.versionNumber)?.name ?? "someone..."
        return HStack {
            Spacer()
            Text("Plan version \(plan.versionNumber) \(action) by \(username)")
                .bold()
            Spacer()
        }
    }

    // Will be empty if there are no views to display
    @ViewBuilder
    func getUpvotedUsersView(planUpvoteViewModel: PlanUpvoteViewModel, version: Int) -> some View {
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

    func getComments(commentsViewModel: CommentsViewModel, version: Int) -> some View {
        let commentOwnerPairs = commentsViewModel.getCommentsForVersion(version: version)

        return ForEach(commentOwnerPairs, id: \.0.id) { comment, user in
            CommentView(viewModel: commentsViewModel, comment: comment, user: user)
        }
    }

}
