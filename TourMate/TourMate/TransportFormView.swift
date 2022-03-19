//
//  TransportFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct TransportFormView: View {
    @StateObject var addPlanViewModel = AddPlanViewModel()

    @Binding var isActive: Bool

    let tripId: String

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

    private func createTransport() -> Transport {
        let planId = tripId + UUID().uuidString
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let transport = Transport(id: planId, tripId: tripId,
                                  planType: .transport,
                                  name: carrierName,
                                  startDate: departureDate,
                                  endDate: arrivalDate,
                                  timeZone: timeZone,
                                  status: status,
                                  creationDate: creationDate,
                                  modificationDate: creationDate,
                                  departureLocation: departureLocation,
                                  departureAddress: departureAddress,
                                  arrivalLocation: arrivalLocation,
                                  arrivalAddress: arrivalAddress,
                                  vehicleDescription: vehicleDescription,
                                  numberOfPassengers: numberOfPassengers)
        return transport
    }

    var body: some View {
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
        .navigationTitle("Transportation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await addPlanViewModel.addPlan(createTransport())
                        isActive = false
                    }
                }
                .disabled(addPlanViewModel.isLoading || addPlanViewModel.hasError)
            }
        }
    }
}

// struct TransportFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportFormView()
//    }
// }
