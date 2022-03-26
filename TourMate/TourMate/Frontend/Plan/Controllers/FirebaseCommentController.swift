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
        ([], "")
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
