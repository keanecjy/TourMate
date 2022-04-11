//
//  AccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import SwiftUI

struct AccommodationView: View {
    @StateObject var accommodationViewModel: AccommodationViewModel
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    @State private var isShowingEditPlanSheet = false
    @State private var selectedVersion: Int

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory = ViewModelFactory()

    init(accommodationViewModel: AccommodationViewModel) {
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: accommodationViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: accommodationViewModel)

        accommodationViewModel.attachDelegate(delegate: commentsViewModel)
        accommodationViewModel.attachDelegate(delegate: planUpvoteViewModel)

        self._accommodationViewModel = StateObject(wrappedValue: accommodationViewModel)
        self._selectedVersion = State(wrappedValue: accommodationViewModel.versionNumber)
    }

    var body: some View {
        if accommodationViewModel.hasError {
            Text("Error occurred")
        } else if accommodationViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                // TODO: Show image
                Picker("Version", selection: $selectedVersion) {
                    ForEach(accommodationViewModel.allVersionNumbers, id: \.magnitude) { num in
                        Text("Version: \(String(num))")
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )

                PlanHeaderView(
                    planStatus: accommodationViewModel.statusDisplay,
                    planOwner: accommodationViewModel.planOwner,
                    creationDateDisplay: accommodationViewModel.creationDateDisplay,
                    lastModifiedDateDisplay: accommodationViewModel.lastModifiedDateDisplay,
                    versionNumberDisplay: accommodationViewModel.versionNumberDisplay) {
                        Text(accommodationViewModel.nameDisplay)
                            .bold()
                            .prefixedWithIcon(named: "bed.double.circle.fill")
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: accommodationViewModel.startDateTimeDisplay,
                           endDate: accommodationViewModel.endDateTimeDisplay)

                LocationView(startLocation: accommodationViewModel.location, endLocation: nil)

                InfoView(additionalInfo: accommodationViewModel.additionalInfoDisplay)

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
                        let viewModel = viewModelFactory.getEditAccommodationViewModel(accommodationViewModel: accommodationViewModel)
                        EditAccommodationView(viewModel: viewModel)
                    }
                }
            }
            .task {
                await accommodationViewModel.fetchVersionedPlansAndListen()
                await accommodationViewModel.updatePlanOwner()
            }
            .onReceive(accommodationViewModel.objectWillChange) {
                if accommodationViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in accommodationViewModel.detachListener() })
        }
    }
}
