//
//  CommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 27/3/22.
//

import Foundation

@MainActor class CommentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var hasError = false
    @Published var isDeleted = false

    @Published var comment: Comment
    @Published var user: User
    @Published var hasUpvotedComment: Bool

    let canEdit: Bool
    let commentController: CommentController = FirebaseCommentController()
    let userController: UserController = FirebaseUserController()

    var id: String {
        comment.id
    }

    var upvoteCount: Int {
        comment.upvotedUserIds.count
    }

    init(comment: Comment, user: User, canEdit: Bool, hasUpvotedComment: Bool) {
        self.comment = comment
        self.user = user
        self.canEdit = canEdit
        self.hasUpvotedComment = hasUpvotedComment
    }

    func upvoteComment() async {
        self.isLoading = true

        let (currentUser, userErrorMessage) = await userController.getUser()

        guard let currentUser = currentUser, userErrorMessage.isEmpty else {
            print("[CommentViewModel] fetch user failed in upvoteComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        let userId = currentUser.id

        let updatedComment = updateUpvotes(id: userId)

        await updateComment(comment: updatedComment)

        self.isLoading = false
    }

    // TODO: how to handle this lol
    func deleteComment(comment: Comment) async {
        self.isLoading = true

        let (hasDeleted, commentErrorMessage) = await commentController.deleteComment(comment: comment)

        guard hasDeleted, commentErrorMessage.isEmpty else {
            print("[CommentViewModel] delete comment failed in deleteComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        await fetchComment()

        self.isLoading = false
    }

    func updateComment(comment: Comment) async {
        self.isLoading = true

        let (hasUpdated, commentErrorMessage) = await commentController.updateComment(comment: comment)

        guard hasUpdated, commentErrorMessage.isEmpty else {
            print("[CommentViewModel] update comment failed in updateComment()")
            self.isLoading = false
            self.hasError = true
            return
        }

        await fetchComment()

        self.isLoading = false
    }

    private func fetchComment() async {
        self.isLoading = true

        let (owner, userErrorMessage) = await userController.getUser(with: "id", value: user.id)

        guard userErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        guard let fetchedUser = owner else {
            self.isLoading = false
            self.isDeleted = true
            return
        }

        // fetch comment
        let (fetchedComment, commentErrorMessage) = await commentController.fetchComment(withCommentId: comment.id)

        guard commentErrorMessage.isEmpty else {
            self.isLoading = false
            self.hasError = true
            return
        }

        guard let fetchedComment = fetchedComment else {
            self.isLoading = false
            self.isDeleted = true
            return
        }

        self.user = fetchedUser
        self.comment = fetchedComment

        self.isLoading = false
    }

    private func updateUpvotes(id: String) -> Comment {
        var newComment = comment

        if newComment.upvotedUserIds.contains(id) {
            newComment.upvotedUserIds = newComment.upvotedUserIds.filter { $0 != id }
            self.hasUpvotedComment = false
        } else {
            newComment.upvotedUserIds.append(id)
            self.hasUpvotedComment = true
        }

        return newComment
    }
}
