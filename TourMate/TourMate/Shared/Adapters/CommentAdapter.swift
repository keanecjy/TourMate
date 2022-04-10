//
//  CommentAdapter.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

class CommentAdapter {
    init() {}

    func toAdaptedComment(comment: Comment) -> FirebaseAdaptedComment {
        comment.toData()
    }

    func toComment(adaptedComment: FirebaseAdaptedComment) -> Comment {
        adaptedComment.toItem()
    }
}

extension Comment {
    fileprivate func toData() -> FirebaseAdaptedComment {
        FirebaseAdaptedComment(planId: planId, planVersionNumber: planVersionNumber,
                               id: id, userId: userId,
                               message: message, creationDate: creationDate,
                               upvotedUserIds: upvotedUserIds)
    }
}

extension FirebaseAdaptedComment {
    fileprivate func toItem() -> Comment {
        Comment(planId: planId, planVersionNumber: planVersionNumber,
                id: id, userId: userId,
                message: message, creationDate: creationDate,
                upvotedUserIds: upvotedUserIds)
    }
}
