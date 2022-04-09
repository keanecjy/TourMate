//
//  AddTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct AddTransportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddTransportViewModel
    var dismissAddPlanView: DismissAction

    var planFormView: some View {
        PlanFormView(viewModel: viewModel) {
            Section("Date & Time") {
                DatePicker("Departure Date",
                           selection: $viewModel.planStartDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])

                DatePicker("Arrival Date",
                           selection: $viewModel.planEndDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])
            }

            Section("Location") {
                AddressTextField(title: "Departure Location", location: $viewModel.startLocation)
                AddressTextField(title: "Arrival Location", location: $viewModel.endLocation)
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error Occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    planFormView
                }
            }
            .navigationTitle("New Transport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addTransport()
                            dismiss()
                            dismissAddPlanView()
                        }
                    }
                    .disabled(!viewModel.canSubmitPlan || viewModel.isLoading || viewModel.hasError)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}
