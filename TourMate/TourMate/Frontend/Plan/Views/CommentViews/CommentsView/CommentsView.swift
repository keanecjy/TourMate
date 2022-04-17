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
    let versionNumber: Int

    private let viewModelFactory = ViewModelFactory()

    var body: some View {
        ActionableContentView {
            ScrollableContentView {
                CommentListView(viewModel: viewModel, forVersion: versionNumber)
            }
        } actionContent: {
            if viewModel.allowUserInteraction {
                AddCommentView(viewModel: viewModelFactory.getAddCommentViewModel(commentsViewModel: viewModel))
            }
        }
        .task {
            await viewModel.fetchCommentsAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct CommentsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentsView()
//    }
// }
