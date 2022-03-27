//
//  CommentListView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentListView: View {
    @ObservedObject var commentsViewModel: CommentsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20.0) {
                ForEach(commentsViewModel.commentViewModels, id: \.id) { viewModel in
                    CommentView(commentViewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading) // Push all comments to leading
        }
        .frame(maxWidth: .infinity, maxHeight: 500.0, alignment: .leading) // push VStack to leading
    }
}

// struct CommentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentListView()
//    }
// }
