//
//  AddCommentViewModel.swift
//  TourMate
//
//  Created by Terence Ho on 14/4/22.
//

import Foundation

@MainActor
class AddCommentViewModel: ObservableObject {
    @Published var isLoading: Bool
    @Published var hasError: Bool

    @Published var commentField: String

    private let planId: String
    private var planVersionNumber: Int
    private var commentService: CommentService
    private let userService: UserService

    init(planId: String,
         planVersionNumber: Int,
         commentService: CommentService,
         userService: UserService) {

        self.isLoading = false
        self.hasError = false

        self.commentField = ""

        self.planId = planId
        self.planVersionNumber = planVersionNumber
        self.commentService = commentService
        self.userService = userService
    }

    func addComment() async {
        guard !commentField.isEmpty else {
            return
        }

        self.isLoading = true

        let (user, userErrorMessage) = await userService.getCurrentUser()

        guard let user = user, userErrorMessage.isEmpty else {
            print("[AddCommentViewModel] fetch user failed in addComment()")
            handleError()
            return
        }

        let userId = user.id
        let commentId = planId + "-" + String(planVersionNumber) + "-" + UUID().uuidString

        let comment = Comment(planId: planId,
                              planVersionNumber: planVersionNumber,
                              id: commentId,
                              userId: userId,
                              message: commentField,
                              creationDate: Date(),
                              upvotedUserIds: [])

        let (hasAdded, commentErrorMessage) = await commentService.addComment(comment: comment)

        guard hasAdded, commentErrorMessage.isEmpty else {
            print("[AddCommentViewModel] add comment failed in addComment()")
            handleError()
            return
        }

        self.commentField = ""
        self.isLoading = false
    }
}

// MARK: - State changes
extension AddCommentViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}
