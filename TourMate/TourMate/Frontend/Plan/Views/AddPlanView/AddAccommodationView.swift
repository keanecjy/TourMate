//
//  AddAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import SwiftUI

struct AddAccommodationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddAccommodationViewModel
    var dismissAddPlanView: DismissAction

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
            .navigationTitle("New Accommodation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addAccommodation()
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

// struct AddAccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddAccommodationView()
//    }
// }
