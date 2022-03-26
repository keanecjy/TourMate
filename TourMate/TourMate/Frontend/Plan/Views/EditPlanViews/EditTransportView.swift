//
//  EditTransportView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditTransportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PlanViewModel<Transport>

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
                                Toggle("Confirmed?", isOn: Binding<Bool>(
                                    get: { viewModel.plan.status == PlanStatus.confirmed },
                                    set: { select in
                                        if select {
                                            viewModel.plan.status = PlanStatus.confirmed
                                        } else {
                                            viewModel.plan.status = PlanStatus.proposed
                                        }
                                    })
                                )
                                TextField("Carrier Name", text: $viewModel.plan.name)
                            }
                            Section("Departure Info") {
                                DatePicker("Departure Date",
                                           selection: $viewModel.plan.startDateTime.date,
                                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                           displayedComponents: [.date, .hourAndMinute])
                                TextField("Departure Location", text: $viewModel.plan.startLocation)
                            }
                            Section("Arrival Info") {
                                DatePicker("Arrival Date",
                                           selection: $viewModel.plan.endDateTime.date,
                                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                                           displayedComponents: [.date, .hourAndMinute])
                                TextField("Arrival Location", text: $viewModel.plan.endLocation ?? "")
                            }
                            Section("Vehicle Info") {
                                TextField("Vehicle Description", text: $viewModel.plan.vehicleDescription ?? "")
                                TextField("Number of Passengers", text: $viewModel.plan.numberOfPassengers ?? "")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Transport")
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
                    Button("Delete Transportation", role: .destructive) {
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

// struct EditTransportView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditTransportView()
//    }
// }
