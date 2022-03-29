//
//  MockCommentController.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

class MockCommentService: CommentService {

    var comments: [Comment] = [
        Comment(planId: "0", id: "0", userId: "0", message: "Testing by 0!",
                creationDate: Date(timeIntervalSince1970: 1_651_400_000), upvotedUserIds: ["0", " 1"]),
        Comment(planId: "0", id: "1", userId: "1", message: "Testing by 1!",
                creationDate: Date(timeIntervalSince1970: 1_851_400_000), upvotedUserIds: ["0", " 1", "2"]),
        Comment(planId: "0", id: "2", userId: "0", message: "Testing again by 0!",
                creationDate: Date(timeIntervalSince1970: 1_853_400_000), upvotedUserIds: ["2"]),
        Comment(planId: "0", id: "3", userId: "2",
                message: "This is a very very very very very very very very very very very very " +
                "very very very very very very very very very very very very very very very very " +
                "very very very very very long string",
                creationDate: Date(timeIntervalSince1970: 1_753_400_000), upvotedUserIds: ["1"])
    ]

    func fetchComments(withPlanId planId: String) async -> ([Comment], String) {
        (comments, "")
    }

    func fetchComment(withCommentId id: String) async -> (Comment?, String) {
        (nil, "")
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
