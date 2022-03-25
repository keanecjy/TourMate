//
//  EditTransportView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditTransportView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = EditPlanViewModel()

    let transport: Transport

    @State private var isConfirmed = true
    @State private var carrierName = ""
    @State private var departureDate = Date()
    @State private var arrivalDate = Date()

    @State private var departureLocation = ""
    @State private var departureAddress = ""

    @State private var arrivalLocation = ""
    @State private var arrivalAddress = ""

    @State private var vehicleDescription = ""
    @State private var numberOfPassengers = ""

    init(transport: Transport) {
        self.transport = transport
        self._isConfirmed = State(initialValue: transport.status == .confirmed ? true : false)
        self._carrierName = State(initialValue: transport.name)
        self._departureDate = State(initialValue: transport.startDateTime.date)
        self._arrivalDate = State(initialValue: transport.endDateTime.date)

        self._departureLocation = State(initialValue: transport.startLocation)

        self._arrivalLocation = State(initialValue: transport.endLocation ?? "")

        self._vehicleDescription = State(initialValue: transport.vehicleDescription ?? "")
        self._numberOfPassengers = State(initialValue: transport.numberOfPassengers ?? "")
    }

    private func createUpdatedTransport() -> Transport {
        let planId = transport.id
        let tripId = transport.tripId
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = transport.creationDate
        let transport = Transport(id: planId,
                                  tripId: tripId,
                                  name: carrierName,
                                  startDateTime: DateTime(date: departureDate),
                                  endDateTime: DateTime(date: arrivalDate),
                                  startLocation: departureLocation,
                                  endLocation: arrivalLocation,
                                  status: status,
                                  creationDate: creationDate,
                                  modificationDate: Date(),
                                  vehicleDescription: vehicleDescription,
                                  numberOfPassengers: numberOfPassengers)
        return transport
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else {
                    Form {
                        Section {
                            Toggle("Confirmed?", isOn: $isConfirmed)
                            TextField("Carrier Name", text: $carrierName)
                            DatePicker("Departure Date",
                                       selection: $departureDate,
                                       displayedComponents: [.date, .hourAndMinute])
                            DatePicker("Arrival Date",
                                       selection: $arrivalDate,
                                       displayedComponents: [.date, .hourAndMinute])
                        }
                        Section("Departure Info") {
                            TextField("Departure Location", text: $departureLocation)
                            TextField("Departure Address", text: $departureAddress)
                        }
                        Section("Arrival Info") {
                            TextField("Arrival Location", text: $arrivalLocation)
                            TextField("Arrival Address", text: $arrivalAddress)
                        }
                        Section("Vehicle Info") {
                            TextField("Vehicle Description", text: $vehicleDescription)
                            TextField("Number of Passengers", text: $numberOfPassengers)
                        }
                    }
                    .navigationTitle("Edit Transport")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task {
                                    await viewModel.updatePlan(plan: createUpdatedTransport())
                                    dismiss()
                                }
                            }
                            .disabled(viewModel.isLoading || viewModel.hasError)
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
                                    await viewModel.deletePlan(plan: createUpdatedTransport())
                                    dismiss()
                                }
                            }
                            .disabled(viewModel.isLoading || viewModel.hasError)
                        }
                    }
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
