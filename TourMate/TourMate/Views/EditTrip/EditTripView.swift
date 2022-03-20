//
//  EditTripView.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import SwiftUI

struct EditTripView: View {

    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: TripViewModel

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else {
                    Form {
                        TextField("Trip Name", text: $viewModel.trip.name)
                        DatePicker(
                            "Start Date",
                            selection: $viewModel.trip.startDate,
                            displayedComponents: [.date]
                        )
                        DatePicker(
                            "End Date",
                            selection: $viewModel.trip.endDate,
                            displayedComponents: [.date]
                        )
                        TextField("Image URL", text: $viewModel.trip.imageUrl ?? "")
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updateTrip()
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
                            await viewModel.deleteTrip()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }
            }
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
