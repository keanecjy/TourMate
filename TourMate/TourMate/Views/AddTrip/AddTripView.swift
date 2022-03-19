//
//  AddTripView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AddTripView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = AddTripViewModel()

    @State private var tripName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var imageUrl = ""

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else {
                    Form {
                        TextField("Trip Name", text: $tripName)
                        DatePicker(
                            "Start Date",
                            selection: $startDate,
                            displayedComponents: [.date]
                        )
                        DatePicker(
                            "End Date",
                            selection: $endDate,
                            displayedComponents: [.date]
                        )
                        TextField("Image URL", text: $imageUrl)
                    }
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addTrip(name: tripName,
                                                    startDate: startDate,
                                                    endDate: endDate,
                                                    imageUrl: imageUrl)
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }
            }
        }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
