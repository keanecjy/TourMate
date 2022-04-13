//
//  AddActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddActivityViewModel
    var dismissAddPlanView: DismissAction

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error Occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    ActivityFormView(
                        activityFormViewModel: viewModel,
                        searchViewModel: viewModelFactory.getSearchViewModel(location: viewModel.trip.location))
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addActivity()
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

// struct AddActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddActivityView()
//    }
// }
