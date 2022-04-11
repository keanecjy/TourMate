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
    @State private var selectedVersion: Int

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory = ViewModelFactory()

    init(transportViewModel: TransportViewModel) {
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: transportViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: transportViewModel)

        transportViewModel.attachDelegate(delegate: commentsViewModel)
        transportViewModel.attachDelegate(delegate: planUpvoteViewModel)

        self._transportViewModel = StateObject(wrappedValue: transportViewModel)
        self._selectedVersion = State(wrappedValue: transportViewModel.versionNumber)
    }

    var body: some View {
        if transportViewModel.hasError {
            Text("Error occurred")
        } else if transportViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                // TODO: Show image
                Picker("Version", selection: $selectedVersion) {
                    ForEach(transportViewModel.allVersionNumbers, id: \.magnitude) { num in
                        Text("Version: \(String(num))")
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )

                PlanHeaderView(
                    planStatus: transportViewModel.statusDisplay,
                    planOwner: transportViewModel.planOwner,
                    creationDateDisplay: transportViewModel.creationDateDisplay,
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
