//
//  EditAccommodationView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditAccommodationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PlanViewModel<Accommodation>

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else {
                    VStack {
                        if !viewModel.canEditPlan {
                            Text("Start date must be before end date")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        Form {
                            ConfirmedToggle(status: $viewModel.plan.status)
                            TextField("Accommodation Name", text: $viewModel.plan.name)
                            DatePicker("Check-in Date",
                                       selection: $viewModel.plan.startDateTime.date,
                                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                       displayedComponents: [.date, .hourAndMinute])
                            DatePicker("Check-out Date",
                                       selection: $viewModel.plan.endDateTime.date,
                                       in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                       displayedComponents: [.date, .hourAndMinute])
                            TextField("Address", text: $viewModel.plan.startLocation)
                            TextField("Phone", text: $viewModel.plan.phone ?? "")
                            TextField("website", text: $viewModel.plan.website ?? "")
                        }
                    }
                }
            }
            .navigationTitle("Edit Accommodation")
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
                    Button("Delete Accommodation", role: .destructive) {
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

// struct EditAccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditAccommodationView()
//    }
// }
