//
//  CommentView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

// Single Comment View
struct CommentView: View {

    @ObservedObject var viewModel: CommentsViewModel
    var comment: Comment
    var user: User

    var body: some View {
        HStack(alignment: .bottom, spacing: 10.0) { // telegram style alignment
            CommentIconView(imageUrl: user.imageUrl)

            CommentTextView(viewModel: viewModel, user: user, comment: comment)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .cornerRadius(20)
        }
    }
}

// struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
// }
