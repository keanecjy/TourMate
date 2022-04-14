//
//  PlanDiffView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct PlanDiffView<T: Plan, Content: View>: View {
    @Environment(\.dismiss) var dismiss

    var planViewModel: PlanDisplayViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    private let content: Content

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel, content: Content) {
        self.planViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.content = content
    }

    var body: some View {
        HStack(spacing: 5.0) {
            PlanDiffSingleView(planDisplayViewModel: planViewModel,
                               commentsViewModel: commentsViewModel,
                               planUpvoteViewModel: planUpvoteViewModel,
                               content: content)
            Divider()

            PlanDiffSingleView(planDisplayViewModel: planViewModel,
                               commentsViewModel: commentsViewModel,
                               planUpvoteViewModel: planUpvoteViewModel,
                               content: content)
        }
    }
}
