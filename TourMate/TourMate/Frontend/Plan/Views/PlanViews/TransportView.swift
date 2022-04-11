//
//  TransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct TransportView: View {
    @StateObject var transportViewModel: TransportViewModel
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory = ViewModelFactory()

    init(transportViewModel: TransportViewModel) {
        self._transportViewModel = StateObject(wrappedValue: transportViewModel)
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: transportViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: transportViewModel)
    }

    var body: some View {
        if transportViewModel.hasError {
            Text("Error occurred")
        } else if transportViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                PlanHeaderView(
                    planStatus: transportViewModel.statusDisplay,
                    planOwner: transportViewModel.planOwner,
                    creationDateDisplay: transportViewModel.creationDateDisplay,
                    lastModifier: transportViewModel.planLastModifier,
                    lastModifiedDateDisplay: transportViewModel.lastModifiedDateDisplay,
                    versionNumberDisplay: transportViewModel.versionNumberDisplay) {
                        Text(transportViewModel.nameDisplay)
                            .bold()
                            .prefixedWithIcon(named: "car.circle.fill")
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: transportViewModel.startDateTimeDisplay,
                           endDate: transportViewModel.endDateTimeDisplay)

                LocationView(startLocation: transportViewModel.startLocation,
                             endLocation: transportViewModel.endLocation)

                InfoView(additionalInfo: transportViewModel.additionalInfoDisplay)

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
                            .getEditTransportViewModel(transportViewModel: transportViewModel)
                        EditTransportView(viewModel: viewModel)
                    }
                }
            }
            .task {
                await transportViewModel.fetchVersionedPlansAndListen()
                await transportViewModel.updatePlanOwner()
            }
            .onReceive(transportViewModel.objectWillChange) {
                if transportViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in transportViewModel.detachListener() })
        }
    }
}
