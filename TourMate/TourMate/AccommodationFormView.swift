//
//  AccommodationFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AccommodationFormView: View {
    @StateObject var addPlanViewModel = AddPlanViewModel()

    @Binding var isActive: Bool

    let tripId: String

    @State private var isConfirmed = true
    @State private var accommodationName = ""
    @State private var checkInDate = Date()
    @State private var checkOutDate = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    private func createAccommodation() -> Accommodation {
        let planId = tripId + UUID().uuidString
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let accommodation = Accommodation(id: planId, tripId: tripId,
                                          planType: .accommodation,
                                          name: accommodationName,
                                          startDate: checkInDate,
                                          endDate: checkOutDate,
                                          timeZone: timeZone,
                                          status: status,
                                          creationDate: creationDate,
                                          modificationDate: creationDate,
                                          address: address,
                                          phone: phone,
                                          website: website)
        return accommodation
    }

    var body: some View {
        Form {
            Toggle("Confirmed?", isOn: $isConfirmed)
            TextField("Accommodation Name", text: $accommodationName)
            DatePicker("Check-in Date",
                       selection: $checkInDate,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("Check-out Date",
                       selection: $checkOutDate,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Address", text: $address)
            TextField("Phone", text: $phone)
            TextField("website", text: $website)
        }
        .navigationTitle("Accommodation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await addPlanViewModel.addPlan(createAccommodation())
                        isActive = false
                    }
                }
                .disabled(addPlanViewModel.isLoading || addPlanViewModel.hasError)
            }
        }
    }
}

// struct AccommodationFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockPlanController = MockPlanController()
//        let plansViewModel = PlansViewModel(planController: mockPlanController, tripId: "0")
//        let trip = Trip(id: "0", name: "West Coast Summer",
//                        startDate: Date(timeIntervalSince1970: 1_651_442_400),
//                        endDate: Date(timeIntervalSince1970: 1_651_480_400),
//                        imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
//                        creatorUserId: "0")
//        let tripView = TripView(plansViewModel: plansViewModel, trip: trip)
//        AccommodationFormView(isActive: tripView.$isActive, tripId: tripView.trip.id)
//    }
// }
