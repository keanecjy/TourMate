//
//  EditCommentView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct EditCommentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var commentsViewModel: CommentsViewModel
    var comment: Comment

    @State var updatedMessage: String

    init(commentsViewModel: CommentsViewModel, comment: Comment) {
        self.commentsViewModel = commentsViewModel
        self.comment = comment
        self._updatedMessage = State(initialValue: comment.message)
    }

    var body: some View {
        NavigationView {
            Group {
                if commentsViewModel.hasError {
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
                            await commentsViewModel.updateComment(comment: comment, withMessage: updatedMessage)

                            dismiss()
                        }
                    }
                    .disabled(commentsViewModel.isLoading || commentsViewModel.hasError)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .disabled(commentsViewModel.isLoading)
                }

                ToolbarItem(placement: .bottomBar) {
                    Button("Delete Comment", role: .destructive) {
                        Task {
                            await commentsViewModel.deleteComment(comment: comment)

                            dismiss()
                        }
                    }
                    .disabled(commentsViewModel.isLoading || commentsViewModel.hasError)
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
