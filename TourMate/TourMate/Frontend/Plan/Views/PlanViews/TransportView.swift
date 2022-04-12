//
//  TransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct TransportView: View {
    @StateObject var planViewModel: TransportViewModel
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory: ViewModelFactory

    init(planViewModel: TransportViewModel) {
        self.viewModelFactory = ViewModelFactory()
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)

        planViewModel.attachDelegate(delegate: commentsViewModel)
        planViewModel.attachDelegate(delegate: planUpvoteViewModel)

        self._planViewModel = StateObject(wrappedValue: planViewModel)
    }

    var body: some View {
        if planViewModel.hasError {
            Text("Error occurred")
        } else if planViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                PlanHeaderView(
                    planStatus: planViewModel.statusDisplay,
                    planOwner: planViewModel.planOwner,
                    creationDateDisplay: planViewModel.creationDateDisplay,
                    lastModifier: planViewModel.planLastModifier,
                    lastModifiedDateDisplay: planViewModel.lastModifiedDateDisplay,
                    versionNumberDisplay: planViewModel.versionNumberDisplay) {
                        Text(planViewModel.nameDisplay)
                            .bold()
                            .prefixedWithIcon(named: "car.circle.fill")
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: planViewModel.startDateTimeDisplay,
                           endDate: planViewModel.endDateTimeDisplay)

                LocationView(startLocation: planViewModel.startLocation,
                             endLocation: planViewModel.endLocation)

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
                        let viewModel = viewModelFactory
                            .getEditTransportViewModel(transportViewModel: planViewModel)
                        EditTransportView(viewModel: viewModel)
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
            .onDisappear(perform: { () in planViewModel.detachListener() })
        }
    }
}
