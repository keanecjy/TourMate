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
    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        if viewModel.hasError {
            Text("Error Occurred")
        } else {
            VStack(spacing: 15.0) {
                CommentListView(viewModel: viewModel)

                AddCommentView(viewModel: viewModelFactory.getAddCommentViewModel(commentsViewModel: viewModel))
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20.0)
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
