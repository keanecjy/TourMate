//
//  CommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import Foundation

@MainActor class CommentViewModel: ObservableObject {
    @Published var comment: Comment
    @Published var user: User
    @Published var hasUpvotedComment = false
    let canEdit: Bool

    var id: String {
        comment.id
    }

    var upvoteCount: Int {
        comment.upvotedUserIds.count
    }

    init(comment: Comment, user: User, canEdit: Bool) {
        self.comment = comment
        self.user = user
        self.canEdit = canEdit
    }
}
