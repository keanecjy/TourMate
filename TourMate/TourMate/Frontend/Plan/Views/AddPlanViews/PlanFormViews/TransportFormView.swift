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
    @State private var departureLocation = ""

    @State private var arrivalDate = Date()
    @State private var arrivalLocation = ""

    @State private var vehicleDescription = ""
    @State private var numberOfPassengers = ""

    private func createTransport() -> Transport {
        let planId = tripId + UUID().uuidString
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let upvotedUserIds: [String] = []
        let transport = Transport(id: planId, tripId: tripId,
                                  name: carrierName.isEmpty ? "Transportation" : carrierName,
                                  startDateTime: DateTime(date: departureDate),
                                  endDateTime: DateTime(date: arrivalDate),
                                  startLocation: departureLocation,
                                  endLocation: arrivalLocation,
                                  status: status,
                                  creationDate: creationDate,
                                  modificationDate: creationDate,
                                  upvotedUserIds: upvotedUserIds,
                                  vehicleDescription: vehicleDescription,
                                  numberOfPassengers: numberOfPassengers)
        return transport
    }

    var body: some View {
        Form {
            Section {
                Toggle("Confirmed?", isOn: $isConfirmed)
                TextField("Carrier Name", text: $carrierName)
            }
            Section("Departure Info") {
                DatePicker("Departure Date",
                           selection: $departureDate,
                           displayedComponents: [.date, .hourAndMinute])
                TextField("Departure Location", text: $departureLocation)
            }
            Section("Arrival Info") {
                DatePicker("Arrival Date",
                           selection: $arrivalDate,
                           displayedComponents: [.date, .hourAndMinute])
                TextField("Arrival Location", text: $arrivalLocation)
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
