//
//  UpvotePlanView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct UpvotePlanView: View {

    @ObservedObject var viewModel: PlanViewModel
    let displayName: Bool

    init(viewModel: PlanViewModel, displayName: Bool = true) {
        self.viewModel = viewModel
        self.displayName = displayName
    }

    var body: some View {
        HStack(spacing: 16) {
            UpvoteButton(hasUpvoted: viewModel.userHasUpvotedPlan,
                         action: viewModel.upvotePlan)

            UpvotedUsersView(upvotedUsers: viewModel.upvotedUsers, displayName: displayName)
        }
    }
}

// struct UpvotePlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpvotePlanView()
//    }
// }
