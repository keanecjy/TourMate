//
//  ActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var activityViewModel: ActivityViewModel
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory = ViewModelFactory()

    init(activityViewModel: ActivityViewModel) {
        self._activityViewModel = StateObject(wrappedValue: activityViewModel)
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: activityViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: activityViewModel)
    }

    var body: some View {
        if activityViewModel.hasError {
            Text("Error occurred")
        } else if activityViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                // TODO: Show image

                PlanHeaderView(planName: activityViewModel.nameDisplay,
                               planStatus: activityViewModel.statusDisplay,
                               planOwner: activityViewModel.planOwner,
                               creationDateDisplay: activityViewModel.creationDateDisplay)

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: activityViewModel.startDateTimeDisplay,
                           endDate: activityViewModel.endDateTimeDisplay)

                LocationView(startLocation: activityViewModel.location, endLocation: nil)

                InfoView(additionalInfo: activityViewModel.additionalInfoDisplay)

                CommentsView(viewModel: commentsViewModel)

                Spacer() // Push everything to the top
            }
            .padding()
            .navigationBarTitle("") // Needed in order to display the nav back button. Best fix is to use .inline
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditActivityView(viewModel: viewModelFactory.getEditActivityViewModel(planViewModel: activityViewModel))
                    }
                }
            }
            .task {
                await activityViewModel.fetchPlanAndListen()
                await activityViewModel.updatePlanOwner()
            }
            .onReceive(activityViewModel.objectWillChange) {
                if activityViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in activityViewModel.detachListener() })
        }
    }
}

// struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView()
//    }
// }
