//
//  TripFromView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct TripFormView: View {

    @State private var tripName = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            TextField("Trip Name", text: $tripName)
        }
        .navigationTitle("Add Trip")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct TripFormView_Previews: PreviewProvider {
    static var previews: some View {
        TripFormView()
    }
}
