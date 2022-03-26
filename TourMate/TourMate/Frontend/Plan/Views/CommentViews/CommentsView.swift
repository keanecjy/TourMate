//
//  CommentsView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

struct CommentsView: View {
    @StateObject var commentViewModel: CommentViewModel
    @State var commentMessage: String = ""

    var body: some View {
        if commentViewModel.hasError {
            Text("Error Occurred")
        } else {
            VStack(spacing: 15.0) {
                Text("Comment List View")

                HStack {
                    TextField("Add a comment", text: $commentMessage)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20.0)

                    Button("Send") {
                        Task {
                            let hasAddedComment = await commentViewModel.addComment(commentMessage: commentMessage)
                            commentMessage = ""

                            if hasAddedComment {
                                await commentViewModel.fetchComments()
                            }
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2.0, alignment: .leading)
            }
            .onAppear {
                Task {
                    await commentViewModel.fetchComments()
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
