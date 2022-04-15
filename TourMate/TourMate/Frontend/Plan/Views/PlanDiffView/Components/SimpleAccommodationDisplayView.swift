//
//  SimpleAccommodationDisplayView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimpleAccommodationDisplayView: View {
    @ObservedObject var planViewModel: AccommodationViewModel
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
