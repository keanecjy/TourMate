//
//  CommentListView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentListView: View {
    @ObservedObject var viewModel: CommentsViewModel

    var body: some View {
        ScrollableContentView {
            ForEach(viewModel.commentOwnerPairs, id: \.0.id) { comment, user in
                CommentView(viewModel: viewModel, comment: comment, user: user)
            }
        }
    }
}

// struct CommentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentListView()
//    }
// }
