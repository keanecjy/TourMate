//
//  FirebaseCommentService.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

class FirebaseCommentService: CommentService {

    private let commentRepository = FirebaseRepository(collectionId: FirebaseConfig.commentCollectionId)

    private let commentAdapter = CommentAdapter()

    weak var commentEventDelegate: CommentEventDelegate?

    func fetchCommentsAndListen(withPlanId planId: String) async {
        print("[FirebaseCommentService] Fetching and listening to comments")

        commentRepository.eventDelegate = self
        await commentRepository.fetchItemsAndListen(field: "planId", isEqualTo: planId)
    }

    func addComment(comment: Comment) async -> (Bool, String) {
        await commentRepository.addItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }

    func deleteComment(comment: Comment) async -> (Bool, String) {
        await commentRepository.deleteItem(id: comment.id)
    }

    func updateComment(comment: Comment) async -> (Bool, String) {
        await commentRepository.updateItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }

    func detachListener() {
        commentRepository.eventDelegate = nil
        commentRepository.detachListener()
    }
}

// MARK: - FirebaseEventDelegate
extension FirebaseCommentService: FirebaseEventDelegate {
    func update(items: [FirebaseAdaptedData], errorMessage: String) async {
        print("[FirebaseCommentService] Updating Comments")

        guard errorMessage.isEmpty else {
            await commentEventDelegate?.update(comments: [], errorMessage: errorMessage)
            return
        }

        guard let adaptedComments = items as? [FirebaseAdaptedComment] else {
            await commentEventDelegate?.update(comments: [], errorMessage: Constants.errorCommentConversion)
            return
        }

        let comments = adaptedComments.map({ commentAdapter.toComment(adaptedComment: $0) })

        await commentEventDelegate?.update(comments: comments, errorMessage: errorMessage)
    }

    func update(item: FirebaseAdaptedData?, errorMessage: String) async {}
}
