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

    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = viewModel.plan.startDateTime.timeZone
        return dateFormatter.string(from: date)
    }

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

                        VStack(alignment: .leading) {
                            // Start Time
                            Text("From")
                                .font(.caption)
                            Text(getDateString(plan.startDateTime.date))
                                .font(.headline)

                            // End Time
                            Text("To")
                                .font(.caption)
                            Text(getDateString(plan.endDateTime.date))
                                .font(.headline)
                        }
                        .padding()

                        VStack(alignment: .leading) {
                            Text("Start Location")
                                .font(.caption)
                            Text(plan.startLocation?.addressFull ?? "No start location provided")

                            Text("End Location")
                                .font(.caption)
                            Text(plan.endLocation?.addressFull ?? "No end location provided")
                        }
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
                        EditPlanView(viewModel: viewModel)
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
