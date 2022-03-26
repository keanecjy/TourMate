//
//  FirebaseCommentController.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

struct FirebaseCommentController: CommentController {

    private let firebasePersistenceManager = FirebasePersistenceManager(collectionId: FirebaseConfig.commentCollectionId)

    private let commentAdapter = CommentAdapter()

    func fetchComments(withPlanId planId: String) async -> ([Comment], String) {
        let (adaptedComments, errorMessage) = await firebasePersistenceManager.fetchItems(field: "planId", isEqualTo: planId)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        guard let adaptedComments = adaptedComments as? [FirebaseAdaptedComment] else {
            return ([], "Unable to convert FirebaseAdaptedData to FirebaseAdaptedComment")
        }

        let comments = adaptedComments.map({ commentAdapter.toComment(adaptedComment: $0) })

        return (comments, "")
    }

    func addComment(comment: Comment) async -> (Bool, String) {
        await firebasePersistenceManager.addItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }

    func deleteComment(comment: Comment) async -> (Bool, String) {
        await firebasePersistenceManager.deleteItem(id: comment.id)
    }

    func updateComment(comment: Comment) async -> (Bool, String) {
        await firebasePersistenceManager.updateItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }
}
