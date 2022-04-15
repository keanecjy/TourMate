//
//  CommentTextView.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import SwiftUI

struct CommentTextView: View {

    var user: User
    var comment: Comment

    init(user: User, comment: Comment) {
        self.user = user
        self.comment = comment
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10.0) {
            HStack(alignment: .top, spacing: 5.0) {
                Text(user.name)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Text(comment.creationDateDescription)
            }

            Text(comment.message)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// struct CommentTextView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentTextView()
//    }
// }
