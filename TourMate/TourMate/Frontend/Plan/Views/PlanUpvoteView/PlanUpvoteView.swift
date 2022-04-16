//
//  PlanUpvoteView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct PlanUpvoteView: View {

    @ObservedObject var viewModel: PlanUpvoteViewModel
    let displayName: Bool

    init(viewModel: PlanUpvoteViewModel, displayName: Bool = true) {
        self.viewModel = viewModel
        self.displayName = displayName
    }

    var body: some View {
        HStack(spacing: 16) {
            UpvoteButton(hasUpvoted: viewModel.userHasUpvotedPlan,
                         action: viewModel.upvotePlan)

            UpvotedUsersView(upvotedUsers: viewModel.upvotedUsers, displayName: displayName)
            Spacer()
        }
        .onAppear {
            Task {
                await viewModel.fetchPlanUpvotesAndListen()
            }
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct UpvotePlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvotePlanView()
//    }
// }
