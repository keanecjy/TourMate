//
//  SimpleActivityDisplayView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimpleActivityDisplayView: View {
    @ObservedObject var planViewModel: ActivityViewModel
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    var body: some View {
        SimplePlanDisplayView(planDisplayViewModel: planViewModel,
                              commentsViewModel: commentsViewModel,
                              planUpvoteViewModel: planUpvoteViewModel) {
            LocationHeaderView(startLocation: planViewModel.location, endLocation: nil)
        }
    }
}
