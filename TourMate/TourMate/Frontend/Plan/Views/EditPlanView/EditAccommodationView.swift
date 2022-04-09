//
//  EditAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct EditAccommodationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditAccommodationViewModel

    init(viewModel: EditAccommodationViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var planFormView: some View {
        PlanFormView(viewModel: viewModel) {
            Section("Date & Time") {
                DatePicker("Check-in Date",
                           selection: $viewModel.planStartDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])

                DatePicker("Check-out Date",
                           selection: $viewModel.planEndDate,
                           in: viewModel.lowerBoundDate...viewModel.upperBoundDate,
                           displayedComponents: [.date, .hourAndMinute])
            }

            Section("Location") {
                AddressTextField(title: "Location", location: $viewModel.location)
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
            .navigationTitle("Edit Accommodation")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(.stack)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updateAccommodation()
                            dismiss()
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
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Accommodation", role: .destructive) {
                        Task {
                            await viewModel.deletePlan()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError || !viewModel.canDeletePlan)
                }
            }
        }
    }
}
