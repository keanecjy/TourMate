//
//  CommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 26/3/22.
//

import Foundation

@MainActor
class CommentsViewModel: ObservableObject {
//    @Published var comments: [Comment]
    @Published var commentUserPair: [(Comment, User)]
    @Published var isLoading: Bool
    @Published var hasError: Bool

    let commentController: CommentController
    let userController: UserController
    let planId: String

    init(planId: String,
         commentController: CommentController = MockCommentController(),
         userController: UserController = MockUserController()) {

        self.planId = planId
        self.commentController = commentController
        self.userController = userController

        self.commentUserPair = []

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

        var seenUsers: [String: User] = [:]
        var commentUserPair: [(Comment, User)] = []

        for comment in comments {
            let userId = comment.userId

            if let user = seenUsers[userId] {
                commentUserPair.append((comment, user))
                continue
            }

            // fetch user if not seen
            let (user, userErrorMessage) = await userController.getUser(with: "id", value: userId)

            if !userErrorMessage.isEmpty {
                print("User cannot be found")
                continue
            }

            if let user = user {
                commentUserPair.append((comment, user))
                seenUsers[userId] = user
            }
        }

        self.commentUserPair = commentUserPair

        self.isLoading = false
    }

    func addComment(commentMessage: String) async -> Bool {
        guard !commentMessage.isEmpty else {
            return false
        }

        self.isLoading = true

        let (user, userErrorMessage) = await userController.getUser()

        guard let user = user, userErrorMessage.isEmpty else {
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
