//
//  SimplePlanView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct SimplePlanView<T: Plan>: View {
    @StateObject var planViewModel: PlanViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    @State private var selectedVersion: Int

    private let viewFactory: ViewFactory

    init(planViewModel: PlanViewModel<T>, initialVersion: Int) {
        let viewModelFactory = ViewModelFactory()
        viewFactory = ViewFactory()

        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        commentsViewModel.allowUserInteraction = false
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)

        self._planViewModel = StateObject(wrappedValue: planViewModel)
        self._selectedVersion = State(wrappedValue: initialVersion)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            HStack {
                Picker("Version", selection: $selectedVersion) {
                    ForEach(planViewModel.allVersionNumbers, id: \.self) { num in
                        Text("Version: \(String(num))").tag(num)
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )
                .onChange(of: selectedVersion, perform: { val in
                    Task {
                        await planViewModel.setVersionNumber(val)
                        await commentsViewModel.filterSpecificVersionComments()
                    }
                })

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
            // Load in after inner views are fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Task {
                    planViewModel.attachDelegate(delegate: commentsViewModel)
                    planViewModel.attachDelegate(delegate: planUpvoteViewModel)
                    await planViewModel.setVersionNumber(selectedVersion)
                    await commentsViewModel.filterSpecificVersionComments()
                }
            }
        }
        .onDisappear {
            planViewModel.detachDelegates()
        }
    }
}