//
//  EditTransportView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/4/22.
//

import SwiftUI

struct EditTransportView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditTransportViewModel

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
            .navigationTitle("Edit Transport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updateTransport()
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
                    Button("Delete Transport", role: .destructive) {
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
