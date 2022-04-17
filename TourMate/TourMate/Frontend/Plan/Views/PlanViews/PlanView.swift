//  PlanView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct PlanView<T: Plan, Content: View>: View {

    @ObservedObject var planViewModel: PlanViewModel<T>
    @StateObject var commentsViewModel: CommentsViewModel
    @StateObject var planUpvoteViewModel: PlanUpvoteViewModel

    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory: ViewModelFactory
    private let viewFactory: ViewFactory
    private let content: Content

    init(planViewModel: PlanViewModel<T>, @ViewBuilder content: () -> Content) {
        self.viewModelFactory = ViewModelFactory()
        self.viewFactory = ViewFactory()

        let commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        let planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)

        self._commentsViewModel = StateObject(wrappedValue: commentsViewModel)
        self._planUpvoteViewModel = StateObject(wrappedValue: planUpvoteViewModel)

        self.planViewModel = planViewModel
        self.content = content()
    }

    var body: some View {
        if planViewModel.hasError {
            Text("Error occurred")
        } else if planViewModel.isLoading {
            ProgressView()
        } else {
            PlanDisplayView(planDisplayViewModel: planViewModel,
                            commentsViewModel: commentsViewModel,
                            planUpvoteViewModel: planUpvoteViewModel,
                            content: content)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    NavigationLink {
                        PlanDiffView(planViewModel: planViewModel,
                                     commentsViewModel: commentsViewModel,
                                     planUpvoteViewModel: planUpvoteViewModel)
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                    }

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
                planViewModel.attachDelegate(delegate: commentsViewModel)
                planViewModel.attachDelegate(delegate: planUpvoteViewModel)
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
