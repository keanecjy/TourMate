//
//  FirebaseCommentController.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

struct FirebaseCommentService: CommentService {

    private let firebaseRepository = FirebaseRepository(collectionId: FirebaseConfig.commentCollectionId)

    private let commentAdapter = CommentAdapter()

    func fetchComments(withPlanId planId: String) async -> ([Comment], String) {
        let (adaptedComments, errorMessage) = await firebaseRepository.fetchItems(field: "planId", isEqualTo: planId)

        guard errorMessage.isEmpty else {
            return ([], errorMessage)
        }

        guard let adaptedComments = adaptedComments as? [FirebaseAdaptedComment] else {
            return ([], "Unable to convert FirebaseAdaptedData to FirebaseAdaptedComment")
        }

        let comments = adaptedComments.map({ commentAdapter.toComment(adaptedComment: $0) })

        return (comments, "")
    }

    func fetchComment(withCommentId id: String) async -> (Comment?, String) {
        let (adaptedComment, errorMessage) = await firebaseRepository.fetchItem(id: id)

        guard errorMessage.isEmpty,
              adaptedComment != nil
        else {
            return (nil, errorMessage)
        }
        
        guard let adaptedComment = adaptedComment as? FirebaseAdaptedComment else {
            return (nil, "Unable to convert FirebaseAdaptedData to FirebaseAdaptedComment")
        }

        return (commentAdapter.toComment(adaptedComment: adaptedComment), "")
    }

    func addComment(comment: Comment) async -> (Bool, String) {
        await firebaseRepository.addItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }

    func deleteComment(comment: Comment) async -> (Bool, String) {
        await firebaseRepository.deleteItem(id: comment.id)
    }

    func updateComment(comment: Comment) async -> (Bool, String) {
        await firebaseRepository.updateItem(id: comment.id, item: commentAdapter.toAdaptedComment(comment: comment))
    }
}
