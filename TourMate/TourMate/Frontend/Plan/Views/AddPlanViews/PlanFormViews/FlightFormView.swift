//
//  FlightFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct FlightFormView: View {
    @StateObject var addPlanViewModel = AddPlanViewModel()

    @Binding var isActive: Bool

    let tripId: String

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

    private func createFlight() -> Flight {
        let planId = tripId + UUID().uuidString
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let flight = Flight(id: planId, tripId: tripId,
                            startDateTime: DateTime(date: departureDate),
                            endDateTime: DateTime(date: arrivalDate),
                            startLocation: departureLocation,
                            endLocation: arrivalLocation,
                            status: status,
                            creationDate: creationDate,
                            modificationDate: creationDate,
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
        .navigationTitle("Flight")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await addPlanViewModel.addPlan(createFlight())
                        isActive = false
                    }
                }
                .disabled(addPlanViewModel.isLoading || addPlanViewModel.hasError)
            }
        }
    }
}

// struct FlightFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightFormView()
//    }
// }
