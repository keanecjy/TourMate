//
//  AddTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct AddTransportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AddTransportViewModel
    var dismissAddPlanView: DismissAction

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error Occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    TransportFormView(viewModel: viewModel)
                }
            }
            .navigationTitle("New Transport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addTransport()
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
