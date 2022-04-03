//
//  CommentTextView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentTextView: View {
    @ObservedObject var viewModel: CommentsViewModel
    var user: User
    var comment: Comment

    @State var isShowingEditCommentSheet = false

    var upvoteImageName: String {
        let userHasUpvotedComment = viewModel.getUserHasUpvotedComment(comment: comment)
        if userHasUpvotedComment {
            return "hand.thumbsup.fill"
        } else {
            return "hand.thumbsup"
        }
    }

    init(viewModel: CommentsViewModel, user: User, comment: Comment) {
        self.viewModel = viewModel
        self.user = user
        self.comment = comment
    }

    var body: some View {
        if viewModel.hasError {
            Text("Error occured")
        } else {
            VStack(alignment: .leading, spacing: 10.0) {
                HStack(alignment: .top, spacing: 5.0) {
                    Text(user.name)
                        .bold()
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    Text(comment.creationDateDescription)
                }

                Text(comment.message)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10.0) {
                    if viewModel.getUserCanEditComment(comment: comment) {
                        Button {
                            self.isShowingEditCommentSheet = true
                        } label: {
                            Text("Edit")
                                .foregroundColor(.blue)
                                .padding([.vertical], 4.0)
                        }
                    }

                    Button {
                        Task {
                            await viewModel.upvoteComment(comment: comment)
                        }
                    } label: {
                        Text("Like")
                            .foregroundColor(.blue)
                            .padding([.vertical], 4.0)
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
            .disabled(viewModel.isLoading || viewModel.hasError)
            .sheet(isPresented: $isShowingEditCommentSheet) {
                // on dismiss
                print("Sheet dismissed")
            } content: {
                EditCommentView(viewModel: viewModel, comment: comment)
            }
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
