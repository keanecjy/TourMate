//
//  PlanDiffButton.swift
//  TourMate
//
//  Created by Keane Chan on 17/4/22.
//

import SwiftUI

struct PlanDiffButton<T: Plan>: View {
    @ObservedObject var planViewModel: PlanViewModel<T>
    @ObservedObject var commentsViewModel: CommentsViewModel
    @ObservedObject var planUpvoteViewModel: PlanUpvoteViewModel

    var body: some View {
        NavigationLink {
            PlanDiffView(planViewModel: planViewModel,
                         commentsViewModel: commentsViewModel,
                         planUpvoteViewModel: planUpvoteViewModel)
        } label: {
            Image(systemName: "arrow.left.arrow.right")
        }
    }
}
