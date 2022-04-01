//
//  EditPlanView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditPlanView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PlanViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        if !viewModel.canEditPlan {
                            Text("Start date must be before end date")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        Form {
                            ConfirmedToggle(status: $viewModel.plan.status)
                            TextField("Event Name", text: $viewModel.plan.name)
                            DatePicker("Start Date",
                                       selection: $viewModel.plan.startDateTime.date,
                                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                       displayedComponents: [.date, .hourAndMinute])
                            DatePicker("End Date",
                                       selection: $viewModel.plan.endDateTime.date,
                                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                       displayedComponents: [.date, .hourAndMinute])
                            AddressTextField("Start Location", text: $viewModel.plan.startLocation)
                            // TODO: Add End Location
                            // TODO: Add Additional Info box
                        }
                    }
                }
            }
            .navigationTitle("Edit Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updatePlan()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.canEditPlan || viewModel.isLoading || viewModel.hasError)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Plan", role: .destructive) {
                        Task {
                            await viewModel.deletePlan()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }
            }
        }
    }
}

// struct EditPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPlanView()
//    }
// }
