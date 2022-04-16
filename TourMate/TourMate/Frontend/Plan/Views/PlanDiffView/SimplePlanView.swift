//
//  SimplePlanView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct SimplePlanView<T: Plan>: View {
    @ObservedObject var planViewModel: PlanViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    @Binding var selectedVersion: Int

    private let viewFactory: ViewFactory

    init(planViewModel: PlanViewModel<T>, initialVersion: Binding<Int>,
         commentsViewModel: CommentsViewModel, planUpvoteViewModel: PlanUpvoteViewModel) {
        self.planViewModel = planViewModel
        self._selectedVersion = initialVersion

        viewFactory = ViewFactory()

        self.commentsViewModel = commentsViewModel
        self.commentsViewModel.allowUserInteraction = false

        self.planUpvoteViewModel = planUpvoteViewModel
    }

    func handleVersionChange(version: Int) {
        Task {
            await planViewModel.setVersionNumber(version)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            HStack(spacing: 5.0) {
                VersionPickerView(selectedVersion: $selectedVersion,
                                  onChange: { val in handleVersionChange(version: val) },
                                  versionNumbers: planViewModel.allVersionNumbersSortedDesc)

                RestoreButtonView(planViewModel: planViewModel)

                Spacer()

                SimplePlanModifierView(planOwner: planViewModel.planOwner,
                                       planLastModifier: planViewModel.planLastModifier)
            }

            viewFactory.getSimplePlanDisplayView(planViewModel: planViewModel,
                                                 commentsViewModel: commentsViewModel,
                                                 planUpvoteViewModel: planUpvoteViewModel)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            planViewModel.attachDelegate(delegate: planUpvoteViewModel)
            handleVersionChange(version: selectedVersion)
        }
        .onDisappear {
            planViewModel.detachDelegates()
        }
    }
}
