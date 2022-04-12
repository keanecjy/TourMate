//
//  AddPlanView.swift
//  TourMate
//
//  Created by Keane Chan on 12/4/22.
//

import SwiftUI

struct AddPlanView<T: Plan, Content: View>: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddPlanViewModel<T>
    var dismissAddPlanView: DismissAction

    let planName: String
    let content: Content

    init(viewModel: AddPlanViewModel<T>,
         dismissAddPlanView: DismissAction,
         planName: String,
         @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.dismissAddPlanView = dismissAddPlanView
        self.planName = planName
        self.content = content()
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error Occurred")
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    content
                }
            }
            .navigationTitle("New \(planName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await viewModel.addPlan()
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
