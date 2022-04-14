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

    private let viewModelFactory: ViewModelFactory

    init(planViewModel: PlanViewModel<T>, initialVersion: Int) {
        self.viewModelFactory = ViewModelFactory()

        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)

        self._planViewModel = StateObject(wrappedValue: planViewModel)
        self._selectedVersion = State(initialValue: initialVersion)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
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
                }
            })

            SimplePlanDisplayView(planDisplayViewModel: planViewModel,
                                  commentsViewModel: commentsViewModel,
                                  planUpvoteViewModel: planUpvoteViewModel)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .task {
            planViewModel.attachDelegate(delegate: commentsViewModel)
            planViewModel.attachDelegate(delegate: planUpvoteViewModel)
            await planViewModel.setVersionNumber(selectedVersion)
        }
        .onDisappear {
            planViewModel.detachDelegates()
        }
    }
}
