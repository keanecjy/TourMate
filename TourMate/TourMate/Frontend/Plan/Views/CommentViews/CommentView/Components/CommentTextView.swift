//
//  CommentTextView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentTextView: View {
    @ObservedObject var commentsViewModel: CommentsViewModel
    var user: User
    var comment: Comment

    @State var updatedMessage = ""
    @State var isEditingComment = false

    // Did not include Timezone
    func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm a"
        return dateFormatter.string(from: date)
    }

    var upvoteImageName: String {
        let userHasUpvotedComment = commentsViewModel.getUserHasUpvotedComment(comment: comment)
        if userHasUpvotedComment {
            return "hand.thumbsup.fill"
        } else {
            return "hand.thumbsup"
        }
    }

    init(commentsViewModel: CommentsViewModel, user: User, comment: Comment) {
        self.commentsViewModel = commentsViewModel
        self.user = user
        self.comment = comment
        self._updatedMessage = State(initialValue: comment.message)
    }

    var body: some View {
        if commentsViewModel.hasError {
            Text("Error occured")
        } else {
            VStack(alignment: .leading, spacing: 10.0) {
                HStack(alignment: .top, spacing: 5.0) {
                    Text(user.name)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Text(getDateString(comment.creationDate))
                }

                if isEditingComment {
                    HStack {
                        TextField("Comment", text: $updatedMessage)
                            .background(.white)

                        Button {
                            Task {
                                await commentsViewModel.updateComment(comment: comment, withMessage: updatedMessage)
                                self.isEditingComment = false
                            }
                        } label: {
                            Text("Done")
                                .foregroundColor(.blue)
                        }

                        Button {
                            // TODO: fix update
                            Task {
                                self.updatedMessage = comment.message
                                self.isEditingComment = false
                            }
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    Text(comment.message)
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 10.0) {
                    if commentsViewModel.getUserCanEditComment(comment: comment) {
                        Button {
                            self.isEditingComment = true
                        } label: {
                            Text("Edit")
                                .foregroundColor(.blue)
                        }
                    }

                    Button {
                        Task {
                            await commentsViewModel.upvoteComment(comment: comment)
                        }
                    } label: {
                        Text("Like")
                            .foregroundColor(.blue)
                    }

                    if !comment.upvotedUserIds.isEmpty {
                        HStack {
                            Image(systemName: upvoteImageName)
                                .foregroundColor(.blue)

                            Text(String(comment.upvotedUserIds.count))
                                .foregroundColor(.black)
                        }
                        .padding([.horizontal], 10.0)
                        .padding([.vertical], 4.0)
                        .background(.white)
                        .cornerRadius(20.0)
                    }

                    Spacer()

                    if commentsViewModel.getUserCanEditComment(comment: comment) {
                        Button {
                            Task {
                                await commentsViewModel.deleteComment(comment: comment)
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .disabled(commentsViewModel.isLoading || commentsViewModel.hasError)
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
