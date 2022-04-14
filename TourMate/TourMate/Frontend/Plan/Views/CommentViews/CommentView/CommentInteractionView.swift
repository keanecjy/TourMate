//
//  CommentInteractionVieq.swift
//  TourMate
//
//  Created by Terence Ho on 14/4/22.
//

import SwiftUI

struct CommentInteractionView: View {
    @ObservedObject var viewModel: CommentsViewModel
    var comment: Comment

    @State var isShowingEditCommentSheet = false

    var body: some View {
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
                HStack {
                    Image(systemName: viewModel.getUpvoteImageNameDisplay(comment: comment))
                        .foregroundColor(.blue)

                    Text(viewModel.getUpvoteUserCountDisplay(comment: comment))
                        .foregroundColor(.black)
                }
                .padding([.horizontal], 10.0)
                .padding([.vertical], 4.0)
                .background(.white)
                .cornerRadius(20.0)
            }

            Spacer()
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

// struct CommentInteractionVieq_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentInteractionView()
//    }
// }
