//
//  EditTripView.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import SwiftUI

struct EditTripView: View {

    let trip: Trip

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = EditTripViewModel()

    @State private var tripName: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var imageUrl: String

    init(trip: Trip) {
        self.trip = trip
        self._tripName = State(initialValue: trip.name)
        self._startDate = State(initialValue: trip.startDate)
        self._endDate = State(initialValue: trip.endDate)
        self._imageUrl = State(initialValue: trip.imageUrl ?? "")
    }

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
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updateTrip(id: trip.id,
                                                       name: tripName,
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
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Trip", role: .destructive) {
                        Task {
                            await viewModel.deleteTrip(id: trip.id,
                                                       name: tripName,
                                                       startDate: startDate,
                                                       endDate: endDate,
                                                       imageUrl: imageUrl)
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }
            }
        }
        .onAppear {
            tripName = trip.name
            startDate = trip.startDate
            endDate = trip.endDate
            imageUrl = trip.imageUrl ?? ""
        }
    }
}

/*
struct EditTripView_Previews: PreviewProvider {
    static var previews: some View {
        EditTripView()
    }
}
 */
