//
//  UpvotePlanView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct UpvotePlanView<T: Plan>: View {

    @ObservedObject var viewModel: PlanViewModel<T>
    let displayName: Bool

    init(viewModel: PlanViewModel<T>, displayName: Bool = true) {
        self.viewModel = viewModel
        self.displayName = displayName
    }

    var body: some View {
        HStack(spacing: 10.0) {
            UpvoteButton(hasUpvoted: viewModel.userHasUpvotedPlan,
                         action: viewModel.upvotePlan)

            UpvotedUsersView(upvotedUsers: viewModel.upvotedUsers, displayName: displayName)
        }
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct UpvotePlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvotePlanView()
//    }
// }
