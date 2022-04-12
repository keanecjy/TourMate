//
//  EditPlanView.swift
//  TourMate
//
//  Created by Keane Chan on 12/4/22.
//

import SwiftUI

struct EditPlanView<T: Plan, Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EditPlanViewModel<T>

    let planName: String
    let content: Content

    init(viewModel: EditPlanViewModel<T>,
         planName: String,
         @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.planName = planName
        self.content = content()
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    content
                }
            }
            .navigationTitle("Edit \(planName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updatePlan()
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
                    Button("Delete \(planName)", role: .destructive) {
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
