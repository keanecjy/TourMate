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

    private let planType: String
    private let content: Content

    init(viewModel: AddPlanViewModel<T>,
         dismissAddPlanView: DismissAction,
         planType: String,
         @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.dismissAddPlanView = dismissAddPlanView
        self.planType = planType
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
            .navigationTitle("New \(planType)")
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
