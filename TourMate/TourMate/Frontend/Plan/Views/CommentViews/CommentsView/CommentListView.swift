//
//  CommentListView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentListView: View {
    @ObservedObject var viewModel: CommentsViewModel
    let commentOwnerPairs: [(Comment, User)]

    init(viewModel: CommentsViewModel) {
        self.viewModel = viewModel
        self.commentOwnerPairs = viewModel.commentOwnerPairs
    }

    init(viewModel: CommentsViewModel, forVersion version: Int) {
        self.viewModel = viewModel
        self.commentOwnerPairs = viewModel.getCommentsForVersion(version: version)
    }

    var body: some View {
        ForEach(commentOwnerPairs, id: \.0.id) { comment, user in
            CommentView(viewModel: viewModel, comment: comment, user: user)
        }
    }
}

// struct CommentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentListView()
//    }
// }
