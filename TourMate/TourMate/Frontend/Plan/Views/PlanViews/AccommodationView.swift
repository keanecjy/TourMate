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

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory = ViewModelFactory()

    init(accommodationViewModel: AccommodationViewModel) {
        self._accommodationViewModel = StateObject(wrappedValue: accommodationViewModel)
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: accommodationViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: accommodationViewModel)
    }

    var body: some View {
        if accommodationViewModel.hasError {
            Text("Error occurred")
        } else if accommodationViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                // TODO: Show image

                PlanHeaderView(
                    planStatus: accommodationViewModel.statusDisplay,
                    planOwner: accommodationViewModel.planOwner,
                    creationDateDisplay: accommodationViewModel.creationDateDisplay) {
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
                        EmptyView()
                    }
                }
            }
            .task {
                await accommodationViewModel.fetchPlanAndListen()
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
