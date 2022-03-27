//
//  EditFlightView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditFlightView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PlanViewModel<Flight>

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
                            Section {
                                ConfirmedToggle(status: $viewModel.plan.status)
                                TextField("Airline", text: $viewModel.plan.airline ?? "")
                                TextField("Flight Number", text: $viewModel.plan.flightNumber ?? "")
                                TextField("Seats", text: $viewModel.plan.seats ?? "")
                            }
                            Section("Departure Info") {
                                DatePicker("Departure Date",
                                           selection: $viewModel.plan.startDateTime.date,
                                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                           displayedComponents: [.date, .hourAndMinute])
                                AddressTextField("Departure Address", text: $viewModel.plan.startLocation)
                                TextField("Terminal", text: $viewModel.plan.departureTerminal ?? "")
                                TextField("Gate", text: $viewModel.plan.departureGate ?? "")
                            }
                            Section("Arrival Info") {
                                DatePicker("Arrival Date",
                                           selection: $viewModel.plan.endDateTime.date,
                                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                           displayedComponents: [.date, .hourAndMinute])
                                AddressTextField("Arrival Address", text: $viewModel.plan.endLocation ?? "")
                                TextField("Terminal", text: $viewModel.plan.arrivalTerminal ?? "")
                                TextField("Gate", text: $viewModel.plan.arrivalGate ?? "")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Flight")
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
                    Button("Delete Flight", role: .destructive) {
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

// struct EditFlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditFlightView()
//    }
// }
