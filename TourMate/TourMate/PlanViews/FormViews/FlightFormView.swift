//
//  FlightFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct FlightFormView: View {
    @Binding var isActive: Bool

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

    var body: some View {
        Form {
            Section {
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
            ToolbarItem {
                Button {
                    isActive = false
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

// struct FlightFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlightFormView()
//    }
// }
