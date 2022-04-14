//
//  PlanDiffSingleView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct PlanDiffSingleView<T: Plan, Content: View>: View {
    let planDisplayViewModel: PlanDisplayViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    @State private var selectedVersion: Int

    private let content: Content

    init(planDisplayViewModel: PlanDisplayViewModel<T>, commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel, content: Content) {
        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.content = content
        self._selectedVersion = State(wrappedValue: planDisplayViewModel.versionNumber)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Picker("Version", selection: $selectedVersion) {
                ForEach(planDisplayViewModel.allVersionNumbers, id: \.magnitude) { num in
                    Text("Version: \(String(num))")
                }
            }
            .pickerStyle(.menu)
            .padding([.horizontal])
            .background(
                Capsule().fill(Color.primary.opacity(0.25))
            )

            PlanDisplayView(planDisplayViewModel: planDisplayViewModel,
                            commentsViewModel: commentsViewModel,
                            planUpvoteViewModel: planUpvoteViewModel,
                            content: content)
            .allowsHitTesting(false)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
}
