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
    @State private var selectedVersion: Int

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory = ViewModelFactory()

    init(activityViewModel: ActivityViewModel) {
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: activityViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: activityViewModel)

        activityViewModel.attachDelegate(delegate: commentsViewModel)
        activityViewModel.attachDelegate(delegate: planUpvoteViewModel)

        self._activityViewModel = StateObject(wrappedValue: activityViewModel)
        self._selectedVersion = State(wrappedValue: activityViewModel.versionNumber)
    }

    var body: some View {
        if activityViewModel.hasError {
            Text("Error occurred")
        } else if activityViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                // TODO: Show image
                Picker("Version", selection: $selectedVersion) {
                    ForEach(activityViewModel.allVersionNumbers, id: \.magnitude) { num in
                        Text("Version: \(String(num))")
                    }
                }
                .pickerStyle(.menu)
                .padding([.horizontal])
                .background(
                    Capsule().fill(Color.primary.opacity(0.25))
                )

                PlanHeaderView(
                    planStatus: activityViewModel.statusDisplay,
                    planOwner: activityViewModel.planOwner,
                    creationDateDisplay: activityViewModel.creationDateDisplay,
                    lastModifiedDateDisplay: activityViewModel.lastModifiedDateDisplay,
                    versionNumberDisplay: activityViewModel.versionNumberDisplay) {
                        Text(activityViewModel.nameDisplay)
                            .bold()
                            .prefixedWithIcon(named: "figure.walk.circle.fill")
                }

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: activityViewModel.startDateTimeDisplay,
                           endDate: activityViewModel.endDateTimeDisplay)

                LocationView(startLocation: activityViewModel.location, endLocation: nil)

                InfoView(additionalInfo: activityViewModel.additionalInfoDisplay)

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
                        let viewModel = viewModelFactory.getEditActivityViewModel(activityViewModel: activityViewModel)
                        EditActivityView(viewModel: viewModel)
                    }
                }
            }
            .task {
                await activityViewModel.fetchVersionedPlansAndListen()
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
