//
//  CommentTextView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentTextView: View {
    @ObservedObject var commentViewModel: CommentViewModel
    @State var updatedMessage = ""
    @State var isEditingComment = false

    // Did not include Timezone
    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm a"
        return dateFormatter.string(from: date)
    }

    var upvoteImageName: String {
        if commentViewModel.hasUpvotedComment {
            return "hand.thumbsup.fill"
        } else {
            return "hand.thumbsup"
        }
    }

    init(commentViewModel: CommentViewModel) {
        self.commentViewModel = commentViewModel
        self._updatedMessage = State(initialValue: commentViewModel.comment.message)
    }

    var body: some View {
        if commentViewModel.hasError {
            Text("Error occured")
        } else {
            VStack(alignment: .leading, spacing: 10.0) {
                HStack(alignment: .top, spacing: 5.0) {
                    Text(commentViewModel.user.name)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Text(getDateString(commentViewModel.comment.creationDate))
                }

                if isEditingComment {
                    HStack {
                        TextField("Comment", text: $updatedMessage)
                            .background(.white)

                        Button {
                            Task {
                                await commentViewModel.updateComment(withMessage: updatedMessage)
                                self.isEditingComment = false
                            }
                        } label: {
                            Text("Done")
                                .foregroundColor(.blue)
                        }

                        Button {
                            // TODO: fix update
                            self.updatedMessage = commentViewModel.comment.message
                            self.isEditingComment = false
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Text(commentViewModel.comment.message)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 10.0) {
                    if commentViewModel.canEdit {
                        Button {
                            self.isEditingComment = true
                        } label: {
                            Text("Edit")
                                .foregroundColor(.blue)
                        }
                    }

                    Button {
                        Task {
                            await commentViewModel.upvoteComment()
                        }
                    } label: {
                        Text("Like")
                            .foregroundColor(.blue)
                    }

                    if commentViewModel.upvoteCount > 0 {
                        HStack {
                            Image(systemName: upvoteImageName)
                                .foregroundColor(.blue)

                            Text(String(commentViewModel.upvoteCount))
                                .foregroundColor(.black)
                        }
                        .padding([.horizontal], 10.0)
                        .padding([.vertical], 4.0)
                        .background(.white)
                        .cornerRadius(20.0)
                    }

                    Spacer()

                    if commentViewModel.canEdit {
                        Button {
                            Task {
                                await commentViewModel.deleteComment()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .disabled(commentViewModel.isLoading || commentViewModel.hasError || commentViewModel.isDeleted)
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
