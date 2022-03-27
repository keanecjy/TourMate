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

    @State var isShowingEditCommentSheet = false

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

                Text(comment.message)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10.0) {
                    if commentsViewModel.getUserCanEditComment(comment: comment) {
                        Button {
                            self.isShowingEditCommentSheet = true
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
                }
            }
            .disabled(commentsViewModel.isLoading || commentsViewModel.hasError)
            .sheet(isPresented: $isShowingEditCommentSheet) {
                // on dismiss
                print("Sheet dismissed")
            } content: {
                EditCommentView(commentsViewModel: commentsViewModel, comment: comment)
            }
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
