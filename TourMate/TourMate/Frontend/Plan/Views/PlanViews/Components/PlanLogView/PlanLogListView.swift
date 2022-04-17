//
//  PlanLogDetailView.swift
//  TourMate
//
//  Created by Terence Ho on 16/4/22.
//

import SwiftUI

struct PlanLogListView<T: Plan>: View {

    @State private var selectedVersion: Int
    @State private var showChanges: Bool

    private let viewFactory: ViewFactory

    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    @ObservedObject var commentsViewModel: CommentsViewModel
    @ObservedObject var planUpvoteViewModel: PlanUpvoteViewModel

    init(planDisplayViewModel: PlanDisplayViewModel<T>,
         commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {

        self.selectedVersion = planDisplayViewModel.defaultVersionNumberChoice
        self.showChanges = false

        self.viewFactory = ViewFactory()

        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
    }

    var body: some View {
        ScrollableContentView {
            VStack(alignment: .trailing, spacing: 10.0) {
                Toggle(isOn: $showChanges) {
                    Text("Show Changes")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                if showChanges {
                    HStack {
                        VersionPickerView(selectedVersion: $selectedVersion,
                                          onChange: { _ in },
                                          versionNumbers: planDisplayViewModel.versionNumberChoices,
                                          labels: planDisplayViewModel.versionLabels)

                        if selectedVersion != planDisplayViewModel.defaultVersionNumberChoice {
                            Button {
                                self.selectedVersion = planDisplayViewModel.defaultVersionNumberChoice
                            } label: {
                                Image(systemName: "clear.fill")

                            }
                        }
                    }
                }
            }
            .padding([.horizontal])

            Divider()

            if showChanges {
                ForEach(planDisplayViewModel.allVersionedPlansSortedDesc, id: \.versionNumber) { versionedPlan in

                    if selectedVersion == 0 || selectedVersion == versionedPlan.versionNumber {
                        VStack(alignment: .leading, spacing: 10.0) { // Each Version's section

                            viewFactory.getPlanVersionView(planDisplayViewModel: planDisplayViewModel,
                                                           plan: versionedPlan)

                            viewFactory.getUpvotedUsersView(planUpvoteViewModel: planUpvoteViewModel,
                                                            version: versionedPlan.versionNumber)

                            CommentListView(viewModel: commentsViewModel,
                                            forVersion: versionedPlan.versionNumber)
                        }
                    }
                }
            } else {
                CommentListView(viewModel: commentsViewModel)
            }
        }
    }
}

// struct PlanLogDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogListView()
//    }
// }
