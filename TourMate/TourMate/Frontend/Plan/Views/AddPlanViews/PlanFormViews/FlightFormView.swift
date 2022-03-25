//
//  FlightFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct FlightFormView: View {
    @Binding var isActive: Bool
    @StateObject var viewModel: AddPlanFormViewModel<Flight>

    var body: some View {
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
                TextField("Airline", text: $viewModel.plan.airline ?? "")
                TextField("Flight Number", text: $viewModel.plan.flightNumber ?? "")
                TextField("Seats", text: $viewModel.plan.seats ?? "")
            }
            Section("Departure Info") {
                DatePicker("Departure Date",
                           selection: $viewModel.plan.startDateTime.date,
                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                           displayedComponents: [.date, .hourAndMinute])
                TextField("Departure Location", text: $viewModel.plan.startLocation)
                TextField("Terminal", text: $viewModel.plan.departureTerminal ?? "")
                TextField("Gate", text: $viewModel.plan.departureGate ?? "")
            }
            Section("Arrival Info") {
                DatePicker("Arrival Date",
                           selection: $viewModel.plan.endDateTime.date,
                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                           displayedComponents: [.date, .hourAndMinute])
                TextField("Arrival Location", text: $viewModel.plan.endLocation ?? "")
                TextField("Terminal", text: $viewModel.plan.arrivalTerminal ?? "")
                TextField("Gate", text: $viewModel.plan.arrivalGate ?? "")
            }
        }
        .navigationTitle("Flight")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await viewModel.addPlan()
                        isActive = false
                    }
                }
                .disabled(!viewModel.canAddPlan || viewModel.isLoading || viewModel.hasError)
            }
        }
    }
}

// struct FlightFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightFormView()
//    }
// }
