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
        ScrollView {
            VStack(alignment: .leading, spacing: 20.0) {
                ForEach(viewModel.commentOwnerPairs, id: \.0.id) { comment, user in
                    CommentView(viewModel: viewModel, comment: comment, user: user)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Push all comments to leading
        }
        .frame(height: 500.0, alignment: .leading) // push VStack to leading
        .task {
            await viewModel.fetchCommentsAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}

// struct CommentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentListView()
//    }
// }
