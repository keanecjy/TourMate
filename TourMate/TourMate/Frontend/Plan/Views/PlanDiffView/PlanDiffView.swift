//
//  PlanDiffView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct PlanDiffView<T: Plan>: View {
    @StateObject var leftViewModel: PlanViewModel<T>
    @StateObject var rightViewModel: PlanViewModel<T>

    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    @State private var leftVersion: Int
    @State private var rightVersion: Int

    init(planViewModel: PlanViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {
        let currentVersion = planViewModel.versionNumber

        self._leftVersion = State(wrappedValue: planViewModel.isLatest ? currentVersion - 1 : currentVersion)
        self._rightVersion = State(wrappedValue: planViewModel.versionNumber)

        self._leftViewModel = StateObject(wrappedValue: planViewModel.copy())
        self._rightViewModel = StateObject(wrappedValue: planViewModel.copy())

        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
    }

    var body: some View {
        VStack {
            Text("Summary of changes")
                .bold()

            PlanDiffTextView(planDiffMap: leftViewModel.diffPlan(with: rightViewModel), spacing: 5.0)
                .padding()

            ScrollView {
                HStack(spacing: 5.0) {
                    SimplePlanView(planViewModel: leftViewModel,
                                   initialVersion: $leftVersion,
                                   commentsViewModel: commentsViewModel.copy(),
                                   planUpvoteViewModel: planUpvoteViewModel.copy())

                    Divider()

                    SimplePlanView(planViewModel: rightViewModel,
                                   initialVersion: $rightVersion,
                                   commentsViewModel: commentsViewModel.copy(),
                                   planUpvoteViewModel: planUpvoteViewModel.copy())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
