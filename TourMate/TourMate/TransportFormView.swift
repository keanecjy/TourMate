//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct TransportFormView: View {
    @Binding var isActive: Bool

    @State private var carrierName = ""
    @State private var departureDate = Date()
    @State private var arrivalDate = Date()

    @State private var departureLocation = ""
    @State private var departureAddress = ""

    @State private var arrivalLocation = ""
    @State private var arrivalAddress = ""

    @State private var vehicleDescription = ""
    @State private var numberOfPassengers = ""

    var body: some View {
        Form {
            Section {
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
        .navigationTitle("Transportation")
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

// struct TransportFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportFormView()
//    }
// }
