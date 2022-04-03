//
//  EditCommentView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct EditCommentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CommentsViewModel
    var comment: Comment

    @State var updatedMessage: String

    init(viewModel: CommentsViewModel, comment: Comment) {
        self.viewModel = viewModel
        self.comment = comment
        self._updatedMessage = State(initialValue: comment.message)
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occurred")
                } else {
                    Form {
                        TextField("Message", text: $updatedMessage)
                    }
                }
            }
            .navigationTitle("Edit Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        Task {
                            await viewModel.updateComment(comment: comment, withMessage: updatedMessage)

                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .disabled(viewModel.isLoading)
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Comment", role: .destructive) {
                        Task {
                            await viewModel.deleteComment(comment: comment)

                            dismiss()
                        }
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }
            }
        }
    }
}

// struct EditCommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCommentView()
//    }
// }
