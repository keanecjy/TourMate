//
//  AddTripView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AddTripView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddTripViewModel

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
                    .disabled(!viewModel.canSubmitTrip || viewModel.isLoading || viewModel.hasError)
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

// struct AddTripView_Previews: PreviewProvider {
//     static var previews: some View {
//         let viewModelFactory = ViewModelFactory()
//         AddTripView(viewModel: viewModelFactory.getAddTripViewModel())
//     }
// }
