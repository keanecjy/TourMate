//
//  CommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var commentOwnerPairs: [(Comment, User)]
    @Published var isLoading: Bool
    @Published var hasError: Bool

    let commentController: CommentController
    let userController: UserController
    let planId: String

    var commentPermissions: [String: (Bool, Bool)] = [:] // canEdit, userHasUpvotedComment

    init(planId: String,
         commentController: CommentController = FirebaseCommentController(),
         userController: UserController = FirebaseUserController()) {

        self.planId = planId
        self.commentController = commentController
        self.userController = userController

        self.commentOwnerPairs = []

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
        var fetchedCommentOwnerPairs: [(Comment, User)] = []

        for comment in comments {
            let userId = comment.userId
            let canEdit = userId == currentUser.id
            let userHasUpvotedComment = comment.upvotedUserIds.contains(currentUser.id)

            if let user = seenUsers[userId] {
                fetchedCommentOwnerPairs.append((comment, user))
                continue
            }

            // fetch user if not seen
            let (user, userErrorMessage) = await userController.getUser(with: "id", value: userId)

            if !userErrorMessage.isEmpty {
                print("[CommentsViewModel] fetchComments(): User cannot be found, comment will not render")
                continue
            }

            if let user = user {
                fetchedCommentOwnerPairs.append((comment, user))
                seenUsers[userId] = user
            }

            commentPermissions[comment.id] = (canEdit, userHasUpvotedComment)
        }

        fetchedCommentOwnerPairs.sort {
            $0.0.creationDate > $1.0.creationDate
        }

        self.commentOwnerPairs = fetchedCommentOwnerPairs

        self.isLoading = false
    }

    func addComment(commentMessage: String) async {
        guard !commentMessage.isEmpty else {
            return
        }

        self.isLoading = true

        let (user, userErrorMessage) = await userController.getUser()

        guard let user = user, userErrorMessage.isEmpty else {
            print("[CommentsViewModel] fetch user failed in addComment()")
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
            print("[CommentsViewModel] add comment failed in addComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        await fetchComments()

        self.isLoading = false
    }

    func deleteComment(comment: Comment) async {
        self.isLoading = true

        let (hasDeleted, commentErrorMessage) = await commentController.deleteComment(comment: comment)

        guard hasDeleted, commentErrorMessage.isEmpty else {
            print("[CommentViewModel] delete comment failed in deleteComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        await fetchComments()

        self.isLoading = false
    }

    func upvoteComment(comment: Comment) async {
        self.isLoading = true

        let (currentUser, userErrorMessage) = await userController.getUser()

        guard let currentUser = currentUser, userErrorMessage.isEmpty else {
            print("[CommentViewModel] fetch user failed in upvoteComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        let userId = currentUser.id

        let updatedComment = updateCommentUpvotes(comment: comment, id: userId)

        await updateComment(comment: updatedComment)

        self.isLoading = false
    }

    func updateComment(comment: Comment, withMessage message: String) async {
        self.isLoading = true

        guard !message.isEmpty else {
            self.isLoading = false
            return
        }

        let updatedComment = Comment(planId: comment.planId,
                                     id: comment.id,
                                     userId: comment.userId,
                                     message: message,
                                     creationDate: comment.creationDate,
                                     upvotedUserIds: comment.upvotedUserIds)

        await updateComment(comment: updatedComment)

        self.isLoading = false
    }

    private func updateComment(comment: Comment) async {
        self.isLoading = true

        let (hasUpdated, commentErrorMessage) = await commentController.updateComment(comment: comment)

        guard hasUpdated, commentErrorMessage.isEmpty else {
            print("[CommentViewModel] update comment failed in updateComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        await fetchComments()

        self.isLoading = false
    }

    private func updateCommentUpvotes(comment: Comment, id: String) -> Comment {
        var newComment = comment

        let canEdit = newComment.upvotedUserIds.contains(id)

        if newComment.upvotedUserIds.contains(id) {
            newComment.upvotedUserIds = newComment.upvotedUserIds.filter { $0 != id }
            commentPermissions[newComment.id] = (canEdit, false)
        } else {
            newComment.upvotedUserIds.append(id)
            commentPermissions[newComment.id] = (canEdit, true)
        }

        return newComment
    }

    func getUserHasUpvotedComment(comment: Comment) -> Bool {
        guard let (_, userHasUpvotedComment) = commentPermissions[comment.id] else {
            self.hasError = true
            return false
        }

        return userHasUpvotedComment
    }

    func getUserCanEditComment(comment: Comment) -> Bool {
        guard let (canEdit, _) = commentPermissions[comment.id] else {
            self.hasError = true
            return false
        }

        return canEdit
    }
}
