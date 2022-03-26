//
//  EditFlightView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditFlightView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = EditPlanViewModel()

    let flight: Flight

    @State private var isConfirmed = true
    @State private var departureDate = Date()
    @State private var arrivalDate = Date()
    @State private var airline = ""
    @State private var flightNumber = ""
    @State private var seats = ""

    @State private var departureLocation = ""
    @State private var departureTerminal = ""
    @State private var departureGate = ""

    @State private var arrivalLocation = ""
    @State private var arrivalTerminal = ""
    @State private var arrivalGate = ""

    init(flight: Flight) {
        self.flight = flight
        self._isConfirmed = State(initialValue: flight.status == .confirmed ? true : false)
        self._departureDate = State(initialValue: flight.startDateTime.date)
        self._arrivalDate = State(initialValue: flight.endDateTime.date)
        self._airline = State(initialValue: flight.airline ?? "")
        self._flightNumber = State(initialValue: flight.flightNumber ?? "")
        self._seats = State(initialValue: flight.seats ?? "")

        self._departureLocation = State(initialValue: flight.startLocation)
        self._departureTerminal = State(initialValue: flight.departureTerminal ?? "")
        self._departureGate = State(initialValue: flight.departureGate ?? "")

        self._arrivalLocation = State(initialValue: flight.endLocation ?? "")
        self._arrivalTerminal = State(initialValue: flight.arrivalTerminal ?? "")
        self._arrivalGate = State(initialValue: flight.arrivalGate ?? "")
    }

    private func createUpdatedFlight() -> Flight {
        let planId = self.flight.id
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = self.flight.creationDate
        let upvotedUserIds = flight.upvotedUserIds
        let flight = Flight(id: planId,
                            tripId: self.flight.tripId,
                            startDateTime: DateTime(date: departureDate),
                            endDateTime: DateTime(date: arrivalDate),
                            startLocation: departureLocation,
                            endLocation: arrivalLocation,
                            status: status,
                            creationDate: creationDate,
                            modificationDate: Date(),
                            upvotedUserIds: upvotedUserIds,
                            airline: airline,
                            flightNumber: flightNumber,
                            seats: seats,
                            departureTerminal: departureTerminal,
                            departureGate: departureGate,
                            arrivalTerminal: arrivalTerminal,
                            arrivalGate: arrivalGate)
        return flight
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
                            TextField("Airline", text: $airline)
                            TextField("Flight Number", text: $flightNumber)
                            TextField("Seats", text: $seats)
                        }
                        Section("Departure Info") {
                            DatePicker("Departure Date",
                                       selection: $departureDate,
                                       displayedComponents: [.date, .hourAndMinute])
                            TextField("Departure Location", text: $departureLocation)
                            TextField("Terminal", text: $departureTerminal)
                            TextField("Gate", text: $departureGate)
                        }
                        Section("Arrival Info") {
                            DatePicker("Arrival Date",
                                       selection: $arrivalDate,
                                       displayedComponents: [.date, .hourAndMinute])
                            TextField("Arrival Location", text: $arrivalLocation)
                            TextField("Terminal", text: $arrivalTerminal)
                            TextField("Gate", text: $arrivalGate)
                        }
                    }
                    .navigationTitle("Edit Flight")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task {
                                    await viewModel.updatePlan(plan: createUpdatedFlight())
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
                            Button("Delete Flight", role: .destructive) {
                                Task {
                                    await viewModel.deletePlan(plan: createUpdatedFlight())
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

// struct EditFlightView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditFlightView()
//    }
// }
