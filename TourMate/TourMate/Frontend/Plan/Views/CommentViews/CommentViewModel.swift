//
//  CommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments: [Comment]
    @Published var isLoading: Bool
    @Published var hasError: Bool

    let commentController: CommentController
    let userController: UserController
    let planId: String

    init(planId: String,
         commentController: CommentController = MockCommentController(),
         userController: UserController = FirebaseUserController()) {

        self.planId = planId
        self.commentController = commentController
        self.userController = userController

        self.comments = []

        self.isLoading = false
        self.hasError = false
    }

    func fetchComments() async {
        self.isLoading = true

        let (comments, errorMessage) = await commentController.fetchComments(withPlanId: planId)

        guard errorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        self.comments = comments

        self.isLoading = false
    }

    func addComment(commentMessage: String) async {
        guard !commentMessage.isEmpty else {
            return
        }

        self.isLoading = true

        let (user, userErrorMessage) = await userController.getUser()

        guard let user = user, userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        let userId = user.id
        let commentId = planId + UUID().uuidString

        let comment = Comment(planId: planId,
                              id: commentId,
                              userId: userId,
                              message: commentMessage,
                              creationDate: Date(),
                              upvotedUserIds: [])

        let (hasAdded, commentErrorMessage) = await commentController.addComment(comment: comment)

        guard hasAdded, commentErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        self.isLoading = false
    }

    func deleteComment(comment: Comment) async {
        self.isLoading = true

        let (hasDeleted, commentErrorMessage) = await commentController.deleteComment(comment: comment)

        guard hasDeleted, commentErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        self.isLoading = false
    }

    func updateComment(comment: Comment) async {
        self.isLoading = true

        let (hasUpdated, commentErrorMessage) = await commentController.updateComment(comment: comment)

        guard hasUpdated, commentErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        self.isLoading = false
    }
}
