//
//  MockCommentController.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

class MockCommentController: CommentController {

    var comments: [Comment] = [
        Comment(planId: "0", id: "0", userId: "0", message: "Testing by 0!", creationDate: Date(), upvotedUserIds: []),
        Comment(planId: "0", id: "1", userId: "1", message: "Testing by 1!", creationDate: Date(), upvotedUserIds: []),
        Comment(planId: "0", id: "2", userId: "0", message: "Testing again by 0!", creationDate: Date(), upvotedUserIds: []),
    ]

    func fetchComments(withPlanId planId: String) async -> ([Comment], String) {
        (comments, "")
    }

    func addComment(comment: Comment) async -> (Bool, String) {
        comments.append(comment)
        return (true, "")
    }

    func deleteComment(comment: Comment) async -> (Bool, String) {
        comments = comments.filter({ $0.planId == comment.planId && $0.id != comment.id })
        return (true, "")
    }

    func updateComment(comment: Comment) async -> (Bool, String) {
        guard let index = comments.firstIndex(where: { $0.id == comment.id }) else {
            return (false, "Comment with planId: \(comment.planId) should exist")
        }

        comments[index] = comment
        return (true, "")
    }

    
}
