//
//  PlanView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct PlanView: View {
    @StateObject var planViewModel: PlanViewModel
    @StateObject var commentsViewModel: CommentsViewModel
    @State private var isShowingEditPlanSheet = false
    @State private var isShowingAdditionalInfoSheet = false

    @Environment(\.dismiss) var dismiss

    init(planViewModel: PlanViewModel) {
        self._planViewModel = StateObject(wrappedValue: planViewModel)
        self._commentsViewModel = StateObject(wrappedValue: ViewModelFactory.getCommentsViewModel(planViewModel: planViewModel))
    }

    var body: some View {
        if planViewModel.hasError {
            Text("Error occurred")
        } else if planViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 15.0) {
                // TODO: Show image

                HStack(spacing: 10.0) {
                    PlanStatusView(status: planViewModel.plan.status)

                    if planViewModel.plan.status == .proposed {
                        UpvotePlanView(viewModel: planViewModel)
                    }
                }

                TimingView(plan: planViewModel.plan)
                    .padding()

                if let location = planViewModel.plan.startLocation {
                    MapView(location: location)
                        .padding()
                } else {
                    HStack(alignment: .top) {
                        Image(systemName: "location.fill")
                            .font(.title)
                        Text("No location provided")
                    }
                    .padding()
                }

                if let additionalInfo = planViewModel.plan.additionalInfo {
                    HStack {
                        Image(systemName: "newspaper")
                            .font(.title)

                        Button {
                            isShowingAdditionalInfoSheet.toggle()
                        } label: {
                            Text("Additional Notes")
                        }
                        .sheet(isPresented: $isShowingAdditionalInfoSheet) {
                            AdditionalInfoView(additionalInfo: additionalInfo)
                        }
                    }
                }

                CommentsView(viewModel: commentsViewModel)

                Spacer() // Push everything to the top
            }
            .padding()
            .navigationBarTitle(planViewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditPlanView(viewModel: ViewModelFactory.getEditPlanViewModel(planViewModel: planViewModel))
                    }
                }
            }
            .task {
                await planViewModel.fetchPlanAndListen()
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

// struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
// }
