//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct ActivityFormView: View {
    @StateObject var addPlanViewModel = AddPlanViewModel()

    @Binding var isActive: Bool

    let tripId: String

    @State private var isConfirmed = true
    @State private var eventName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var venue = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    private func createActivity() -> Activity {
        let planId = tripId + UUID().uuidString
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let activity = Activity(id: planId, tripId: tripId,
                                planType: .activity,
                                name: eventName,
                                startDate: startDate,
                                endDate: endDate,
                                timeZone: timeZone,
                                status: status,
                                creationDate: creationDate,
                                modificationDate: creationDate,
                                venue: venue,
                                address: address,
                                phone: phone,
                                website: website)
        return activity
    }

    var body: some View {
        Form {
            Toggle("Confirmed?", isOn: $isConfirmed)
            TextField("Event Name", text: $eventName)
            DatePicker("Start Date",
                       selection: $startDate,
                       displayedComponents: [.date, .hourAndMinute])
            DatePicker("End Date",
                       selection: $endDate,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Venue", text: $venue)
            TextField("Address", text: $address)
            TextField("Phone", text: $phone)
            TextField("Website", text: $website)
        }
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await addPlanViewModel.addPlan(createActivity())
                        isActive = false
                    }
                }
                .disabled(addPlanViewModel.isLoading || addPlanViewModel.hasError)
            }
        }
    }
}

// struct ActivityFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityFormView()
//    }
// }
