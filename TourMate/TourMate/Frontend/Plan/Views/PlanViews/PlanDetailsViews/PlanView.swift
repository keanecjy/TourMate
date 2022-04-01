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

    @Environment(\.dismiss) var dismiss

    var body: some View {
        if viewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                if let plan = viewModel.plan {
                    VStack(alignment: .leading) {
                        HStack(spacing: 10.0) {
                            PlanStatusView(status: plan.status)
                                .padding()

                            if plan.status == .proposed {
                                UpvotePlanView(viewModel: viewModel)
                            }
                        }

                        TimingView(plan: $viewModel.plan)
                            .padding()

                        MapView(location: $viewModel.plan.startLocation)
                            .padding()

                        CommentsView(commentsViewModel: viewModel.commentsViewModel)
                            .padding()

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(viewModel.plan.name)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditPlanView(plan: viewModel.plan, trip: viewModel.trip)
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
