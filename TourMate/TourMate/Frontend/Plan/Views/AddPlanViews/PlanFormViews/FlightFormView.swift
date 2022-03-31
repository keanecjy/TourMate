//
//  FlightFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct FlightFormView: View {
    @Binding var isActive: Bool
    @State var isShowingSearchSheet = false
    @StateObject var viewModel: AddPlanFormViewModel<Flight>

    var body: some View {
        if !viewModel.canAddPlan {
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
                AddressTextField("Departure Address", text: Binding<String>(
                    get: { viewModel.plan.startLocation?.addressFull ?? "" },
                    set: { newValue in
                        viewModel.plan.startLocation?.addressFull = newValue
                    }
                ))
                TextField("Terminal", text: $viewModel.plan.departureTerminal ?? "")
                TextField("Gate", text: $viewModel.plan.departureGate ?? "")
            }
            Section("Arrival Info") {
                DatePicker("Arrival Date",
                           selection: $viewModel.plan.endDateTime.date,
                           in: viewModel.trip.startDateTime.date...viewModel.trip.endDateTime.date,
                           displayedComponents: [.date, .hourAndMinute])
                AddressTextField("Arrival Address", text: Binding<String>(
                    get: { viewModel.plan.endLocation?.addressFull ?? "" },
                    set: { newValue in
                        viewModel.plan.endLocation?.addressFull = newValue
                    }
                ))
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
