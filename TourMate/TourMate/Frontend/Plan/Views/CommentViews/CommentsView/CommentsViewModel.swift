//
//  CommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var commentViewModels: [CommentViewModel]
    @Published var isLoading: Bool
    @Published var hasError: Bool

    let commentController: CommentController
    let userController: UserController
    let planId: String

    init(planId: String,
         commentController: CommentController = FirebaseCommentController(),
         userController: UserController = FirebaseUserController()) {

        self.planId = planId
        self.commentController = commentController
        self.userController = userController

        self.commentViewModels = []

        self.isLoading = false
        self.hasError = false
    }

    func fetchComments() async {
        self.isLoading = true

        let (currentUser, userErrorMessage) = await userController.getUser()
        guard let currentUser = currentUser, userErrorMessage.isEmpty else {
            print("[CommentsViewModel] fetch user failed in fetchComments()")
            self.isLoading = false
            self.hasError = true
            return
        }

        let (comments, errorMessage) = await commentController.fetchComments(withPlanId: planId)

        guard errorMessage.isEmpty else {
            print("[CommentsViewModel] fetch comments failed in fetchComments()")
            self.isLoading = false
            self.hasError = true
            return
        }

        var seenUsers: [String: User] = [:]
        var commentViewModels: [CommentViewModel] = []

        for comment in comments {
            let userId = comment.userId
            let canEdit = userId == currentUser.id

            if let user = seenUsers[userId] {
                commentViewModels.append(CommentViewModel(comment: comment, user: user, canEdit: canEdit))
                continue
            }

            // fetch user if not seen
            let (user, userErrorMessage) = await userController.getUser(with: "id", value: userId)

            if !userErrorMessage.isEmpty {
                print("[CommentsViewModel] fetchComments(): User cannot be found, comment will not render")
                continue
            }

            if let user = user {
                commentViewModels.append(CommentViewModel(comment: comment, user: user, canEdit: canEdit))
                seenUsers[userId] = user
            }
        }

        commentViewModels.sort {
            $0.comment.creationDate > $1.comment.creationDate
        }

        self.commentViewModels = commentViewModels

        self.isLoading = false
    }

    func addComment(commentMessage: String) async -> Bool {
        guard !commentMessage.isEmpty else {
            return false
        }

        self.isLoading = true

        let (user, userErrorMessage) = await userController.getUser()

        guard let user = user, userErrorMessage.isEmpty else {
            print("[CommentsViewModel] fetch user failed in addComment()")
            self.isLoading = false
            self.hasError = true
            return false
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
            print("[CommentsViewModel] add comment failed in addComment()")
            self.isLoading = false
            self.hasError = true
            return false
        }

        self.isLoading = false
        return true
    }

    func deleteComment(comment: Comment) async {
        self.isLoading = true

        let (hasDeleted, commentErrorMessage) = await commentController.deleteComment(comment: comment)

        guard hasDeleted, commentErrorMessage.isEmpty else {
            print("[CommentsViewModel] delete comment failed in deleteComment()")
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
            print("[CommentsViewModel] update comment failed in updateComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        self.isLoading = false
    }
}
