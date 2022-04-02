//
//  EditTripView.swift
//  TourMate
//
//  Created by Rayner Lim on 18/3/22.
//

import SwiftUI

struct EditTripView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: EditTripViewModel

    init(tripViewModel: TripViewModel) {
        self._viewModel = StateObject(wrappedValue: EditTripViewModel(trip: tripViewModel.trip))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    TripFormView(viewModel: viewModel)
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
                    .disabled(!viewModel.canSubmitTrip || viewModel.isLoading || viewModel.hasError)
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
