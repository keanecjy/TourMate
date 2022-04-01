//
//  PlanFormView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 13/3/22.
//

import SwiftUI

struct AddPlanView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddPlanViewModel

    init(trip: Trip) {
        self._viewModel = StateObject(wrappedValue: AddPlanViewModel(trip: trip))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error Occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    PlanFormView(viewModel: viewModel)
                }
            }
            .navigationTitle("New Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addPlan()
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
            }
        }
    }
}

// struct PlanFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanFormView()
//    }
// }
