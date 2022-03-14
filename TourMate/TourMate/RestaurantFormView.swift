//
//  RestaurantFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct RestaurantFormView: View {
    @Binding var isActive: Bool

    @State private var restaurantName = ""
    @State private var date = Date()
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    var body: some View {
        Form {
            TextField("Restaurant Name", text: $restaurantName)
            DatePicker("Date",
                       selection: $date,
                       displayedComponents: [.date, .hourAndMinute])
            TextField("Address", text: $address)
            TextField("Phone", text: $phone)
            TextField("website", text: $website)
        }
        .navigationTitle("Restaurant")
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

// struct RestaurantFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantFormView()
//    }
// }
