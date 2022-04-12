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

    private let planType: String
    private let content: Content

    init(viewModel: EditPlanViewModel<T>,
         planType: String,
         @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.planType = planType
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
            .navigationTitle("Edit \(planType)")
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
                    Button("Delete \(planType)", role: .destructive) {
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
