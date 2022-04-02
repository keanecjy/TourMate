//
//  PlanView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct PlanView: View {
    @StateObject var viewModel: PlanViewModel
    @State private var isShowingEditPlanSheet = false
    @State private var isShowingAdditionalInfoSheet = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        if viewModel.hasError {
            Text("Error occurred")
        } else if viewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 15.0) {
                // TODO: Show image

                HStack(spacing: 10.0) {
                    PlanStatusView(status: viewModel.plan.status)

                    if viewModel.plan.status == .proposed {
                        UpvotePlanView(viewModel: viewModel)
                    }
                }

                TimingView(plan: $viewModel.plan)

                MapView(location: $viewModel.plan.startLocation)

                if let additionalInfo = viewModel.plan.additionalInfo {
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

                CommentsView(viewModel: ViewModelFactory.getCommentsViewModel(planViewModel: viewModel))

                Spacer() // Push everything to the top
            }
            .padding()
            .navigationBarTitle(viewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditPlanView(viewModel: ViewModelFactory.getEditPlanViewModel(planViewModel: viewModel))
                    }
                }
            }
            .task {
                await viewModel.fetchPlanAndListen()
            }
            .onReceive(viewModel.objectWillChange) {
                if viewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in viewModel.detachListener() })
        }
    }
}

// struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
// }
