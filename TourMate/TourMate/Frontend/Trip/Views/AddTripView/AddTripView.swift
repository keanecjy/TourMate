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

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    VStack {
                        Text(viewModel.invalidDurationPrompt)
                            .foregroundColor(.red)
                            .font(.caption)
                        Form {
                            TextField("Trip Name*", text: $viewModel.tripName)
                            DatePicker(
                                "Start Date",
                                selection: $viewModel.startDate,
                                displayedComponents: [.date]
                            )
                            DatePicker(
                                "End Date",
                                selection: $viewModel.endDate,
                                displayedComponents: [.date]
                            )
                            TextField("Image URL", text: $viewModel.imageUrl)
                        }
                    }
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addTrip()
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.canAddTrip || viewModel.isLoading || viewModel.hasError)
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
