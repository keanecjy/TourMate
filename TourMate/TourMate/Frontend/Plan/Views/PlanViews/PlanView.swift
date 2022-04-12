//  PlanView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct PlanView<T: Plan, Content: View>: View {

    @StateObject var planViewModel: PlanViewModel<T>
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel

    @State private var isShowingEditPlanSheet = false
    @State private var selectedVersion: Int

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory: ViewModelFactory
    private let viewFactory: ViewFactory
    private let content: Content

    init(planViewModel: PlanViewModel<T>, @ViewBuilder content: () -> Content) {
        self.viewModelFactory = ViewModelFactory()
        self.viewFactory = ViewFactory()
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)

        planViewModel.attachDelegate(delegate: commentsViewModel)
        planViewModel.attachDelegate(delegate: planUpvoteViewModel)

        self._planViewModel = StateObject(wrappedValue: planViewModel)
        self._selectedVersion = State(wrappedValue: planViewModel.versionNumber)
        self.content = content()
    }

    var body: some View {
        if planViewModel.hasError {
            Text("Error occurred")
        } else if planViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                Picker("Version", selection: $selectedVersion) {
                    ForEach(planViewModel.allVersionNumbers, id: \.magnitude) { num in
                        Text("Version: \(String(num))")
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )

                PlanHeaderView(
                    planStatus: planViewModel.statusDisplay,
                    planOwner: planViewModel.planOwner,
                    creationDateDisplay: planViewModel.creationDateDisplay,
                    lastModifier: planViewModel.planLastModifier,
                    lastModifiedDateDisplay: planViewModel.lastModifiedDateDisplay,
                    versionNumberDisplay: planViewModel.versionNumberDisplay) {
                        Text(planViewModel.nameDisplay)
                            .bold()
                            .prefixedWithIcon(named: planViewModel.prefixedNameDisplay)
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: planViewModel.startDateTimeDisplay,
                           endDate: planViewModel.endDateTimeDisplay)

                content

                InfoView(additionalInfo: planViewModel.additionalInfoDisplay)

                CommentsView(viewModel: commentsViewModel)

                Spacer() // Push everything to the top
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        viewFactory.getEditPlanView(planViewModel: planViewModel)
                    }
                }
            }
            .task {
                await planViewModel.fetchVersionedPlansAndListen()
                await planViewModel.updatePlanOwner()
            }
            .onReceive(planViewModel.objectWillChange) {
                if planViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear {
                planViewModel.detachDelegates()
                planViewModel.detachListener()
            }
        }
    }
}
