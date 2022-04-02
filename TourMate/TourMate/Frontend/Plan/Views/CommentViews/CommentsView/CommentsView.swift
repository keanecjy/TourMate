//
//  CommentsView.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import SwiftUI

// Entire Comments View
struct CommentsView: View {
    @StateObject var viewModel: CommentsViewModel
    @State var commentMessage: String = ""
    var width = UIScreen.main.bounds.width / 2.0

    var body: some View {
        if viewModel.hasError {
            Text("Error Occurred")
        } else {
            VStack(spacing: 15.0) {
                CommentListView(viewModel: viewModel)

                HStack {
                    TextField("Add a comment", text: $commentMessage)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20.0)

                    Button {
                        Task {
                            await viewModel.addComment(commentMessage: commentMessage)
                            commentMessage = ""
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .disabled(viewModel.isLoading || viewModel.hasError)
                }
            }
            .frame(width: width, alignment: .leading)
            .onAppear {
                Task {
                    await viewModel.fetchCommentsAndListen()
                }
            }
            .onDisappear(perform: { () in viewModel.detachListener() })
        }
    }
}

// struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView()
//    }
// }
