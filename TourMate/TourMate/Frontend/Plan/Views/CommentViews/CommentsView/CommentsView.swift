//
//  CommentsView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct CommentsView: View {
    @StateObject var commentsViewModel: CommentsViewModel
    @State var commentMessage: String = ""
    var width = UIScreen.main.bounds.width / 2.0

    var body: some View {
        if commentsViewModel.hasError {
            Text("Error Occurred")
        } else {
            VStack(spacing: 15.0) {
                CommentListView(commentsViewModel: commentsViewModel)

                HStack {
                    TextField("Add a comment", text: $commentMessage)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20.0)

                    Button {
                        Task {
                            await commentsViewModel.addComment(commentMessage: commentMessage)
                            commentMessage = ""
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(commentsViewModel.isLoading || commentsViewModel.hasError)
                }
            }
            .frame(width: width, alignment: .leading)
            .onAppear {
                Task {
                    await commentsViewModel.fetchComments()
                }
            }
        }
    }
}

// struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView()
//    }
// }
