//
//  UpvotePlanView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct UpvotePlanView<T: Plan>: View {

    @ObservedObject var viewModel: PlanViewModel<T>

    var body: some View {
        HStack(spacing: 10.0) {
            UpvoteButton(hasUpvoted: viewModel.userHasUpvotedPlan,
                         action: viewModel.upvotePlan)

            UpvotedUsersView(upvotedUsers: viewModel.upvotedUsers)
        }
        .task {
            await viewModel.fetchPlan()
        }
    }
}

// struct UpvotePlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvotePlanView()
//    }
// }
