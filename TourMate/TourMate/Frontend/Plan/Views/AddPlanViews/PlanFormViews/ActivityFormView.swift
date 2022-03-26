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
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let creationDate = Date()
        let upvotedUserIds: [String] = []
        let activity = Activity(id: planId, tripId: tripId,
                                name: eventName.isEmpty ? "Activity" : eventName,
                                startDateTime: DateTime(date: startDate),
                                endDateTime: DateTime(date: endDate),
                                startLocation: address,
                                status: status,
                                creationDate: creationDate,
                                modificationDate: creationDate,
                                upvotedUserIds: upvotedUserIds,
                                venue: venue,
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
