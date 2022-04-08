//
//  EditPlanView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

// import SwiftUI
//
// struct EditPlanView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject var viewModel: EditPlanViewModel
//
//    init(viewModel: EditPlanViewModel) {
//        self._viewModel = StateObject(wrappedValue: viewModel)
//    }
//
//    var body: some View {
//        NavigationView {
//            Group {
//                if viewModel.hasError {
//                    Text("Error occured")
//                } else if viewModel.isLoading {
//                    ProgressView()
//                } else {
//                    PlanFormView(viewModel: viewModel)
//                }
//            }
//            .navigationTitle("Edit Plan")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Done") {
//                        Task {
//                            await viewModel.updatePlan()
//                            dismiss()
//                        }
//                    }
//                    .disabled(!viewModel.canSubmitPlan || viewModel.isLoading || viewModel.hasError)
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel", role: .destructive) {
//                        dismiss()
//                    }
//                    .disabled(viewModel.isLoading)
//                }
//                ToolbarItem(placement: .bottomBar) {
//                    Button("Delete Plan", role: .destructive) {
//                        Task {
//                            await viewModel.deletePlan()
//                            dismiss()
//                        }
//                    }
//                    .disabled(viewModel.isLoading || viewModel.hasError || !viewModel.canDeletePlan)
//                }
//            }
//        }
//    }
// }

// struct EditPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPlanView()
//    }
// }
