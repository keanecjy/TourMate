//
//  ActivityFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct ActivityFormView: View {
    @Binding var isActive: Bool

    @State private var eventName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var venue = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    var body: some View {
        Form {
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

// struct ActivityFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityFormView()
//    }
// }
