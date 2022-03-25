//
//  EditTripView.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import SwiftUI

struct EditTripView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: TripViewModel

    init(trip: Trip) {
        self._viewModel = StateObject(wrappedValue: TripViewModel(trip: trip))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else {
                    Form {
                        Section("Trip Information") {
                            TextField("Trip Name*", text: $viewModel.trip.name)
                            DatePicker(
                                "Start Date",
                                selection: $viewModel.trip.startDateTime.date,
                                in: Date()...,
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "End Date",
                                selection: $viewModel.trip.endDateTime.date,
                                in: viewModel.fromStartDate,
                                displayedComponents: [.date]
                            )
                            TextField("Image URL", text: $viewModel.trip.imageUrl ?? "")
                        }
                        
                        Section("Invite Users") {
                            InviteUserView(viewModel: viewModel)
                        }
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
                    .disabled(!viewModel.canUpdateTrip || viewModel.isLoading || viewModel.hasError)
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
