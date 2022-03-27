//
//  CommentView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentView: View {

    @ObservedObject var commentViewModel: CommentViewModel

    var body: some View {
        HStack(alignment: .bottom, spacing: 10.0) { // telegram style alignment
            CommentIconView(imageUrl: commentViewModel.user.imageUrl)

            CommentTextView(name: commentViewModel.user.name,
                            message: commentViewModel.comment.message,
                            creationDate: commentViewModel.comment.creationDate)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
        }
    }
}

// struct CommentView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentView()
//    }
// }
