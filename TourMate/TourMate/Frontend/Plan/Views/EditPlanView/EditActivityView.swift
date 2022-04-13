//
//  EditActivityView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import SwiftUI

struct EditActivityView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditActivityViewModel

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    ActivityFormView(
                        activityFormViewModel: viewModel,
                        searchViewModel: viewModelFactory.getSearchViewModel(location: viewModel.trip.location))
                }
            }
            .navigationTitle("Edit Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updateActivity()
                            dismiss()
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
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Activity", role: .destructive) {
                        Task {
                            await viewModel.deletePlan()
                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError || !viewModel.canDeletePlan)
                }
            }
        }
    }
}

// struct EditActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditActivityView()
//    }
// }
