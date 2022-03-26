//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct TransportFormView: View {
    @Binding var isActive: Bool
    @StateObject var viewModel: AddPlanFormViewModel<Transport>

    var body: some View {
        if !viewModel.canAddPlan {
            Text("Start date must be before end date")
                .font(.caption)
                .foregroundColor(.red)
        }
        Form {
            Section {
                ConfirmedToggle(status: $viewModel.plan.status)
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
        .navigationTitle("Transportation")
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

// struct TransportFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportFormView()
//    }
// }
