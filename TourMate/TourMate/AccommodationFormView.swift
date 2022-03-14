//
//  AccommodationFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AccommodationFormView: View {
    @Binding var isActive: Bool

    @State private var accommodationName = ""
    @State private var checkInDate = Date()
    @State private var checkOutDate = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    var body: some View {
        Form {
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

// struct AccommodationFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccommodationFormView()
//    }
// }
