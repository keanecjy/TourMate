//
//  AddAccommodationView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 9/4/22.
//

import SwiftUI

struct AddAccommodationView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddAccommodationViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error Occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    AccommodationFormView(viewModel: viewModel)
                }
            }
            .navigationTitle("New Accommodation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addAccommodation()
                            dismiss()
                            dismissAddPlanView()
                        }
                    }
                    .disabled(!viewModel.canSubmitPlan || viewModel.isLoading || viewModel.hasError)
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

// struct AddAccommodationView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddAccommodationView()
//    }
// }
