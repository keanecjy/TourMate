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

    let planId: String
    private(set) var planVersionNumber: Int
    private(set) var commentService: CommentService
    let userService: UserService

    private var commentPermissions: [String: (Bool, Bool)] // canEdit, userHasUpvotedComment
    var allowUserInteraction: Bool

    private var allVersionedComments: [(Comment, User)]

    // TODO: Fix after Terence changes for comments
    var fetchAllVersions: Bool {
        allowUserInteraction
    }

    var commentCount: Int {
        commentOwnerPairs.count
    }

    init(planId: String,
         planVersionNumber: Int,
         commentService: CommentService,
         userService: UserService,
         allowUserInteraction: Bool = true) {

        self.commentOwnerPairs = []
        self.isLoading = false
        self.hasError = false

        self.planId = planId
        self.planVersionNumber = planVersionNumber
        self.commentService = commentService
        self.userService = userService

        self.commentPermissions = [:]
        self.allowUserInteraction = allowUserInteraction
        self.allVersionedComments = []
    }

    func fetchCommentsAndListen() async {
        commentService.commentEventDelegate = self

        self.isLoading = true
        await commentService.fetchCommentsAndListen(withPlanId: planId)
    }

    func fetchVersionedCommentsAndListen() async {
        commentService.commentEventDelegate = self

        self.isLoading = true
        await commentService.fetchVersionedCommentsAndListen(withPlanId: planId, versionNumber: planVersionNumber)
    }

    func deleteComment(comment: Comment) async {
        self.isLoading = true

        let (hasDeleted, commentErrorMessage) = await commentService.deleteComment(comment: comment)

        guard hasDeleted, commentErrorMessage.isEmpty else {
            print("[CommentViewModel] delete comment failed in deleteComment()")
            handleError()
            return
        }

        self.isLoading = false
    }

    func upvoteComment(comment: Comment) async {
        self.isLoading = true

        let (currentUser, userErrorMessage) = await userService.getCurrentUser()

        guard let currentUser = currentUser, userErrorMessage.isEmpty else {
            print("[CommentViewModel] fetch user failed in upvoteComment()")
            handleError()
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
                                     planVersionNumber: planVersionNumber,
                                     id: comment.id,
                                     userId: comment.userId,
                                     message: message,
                                     creationDate: comment.creationDate,
                                     upvotedUserIds: comment.upvotedUserIds)

        await updateComment(comment: updatedComment)

        self.isLoading = false
    }

    func getUserHasUpvotedComment(comment: Comment) -> Bool {
        guard let (_, userHasUpvotedComment) = commentPermissions[comment.id] else {
            handleError()
            return false
        }

        return userHasUpvotedComment
    }

    func getUserCanEditComment(comment: Comment) -> Bool {
        guard let (canEdit, _) = commentPermissions[comment.id] else {
            handleError()
            return false
        }

        return canEdit
    }

    func getUpvoteImageNameDisplay(comment: Comment) -> String {
        let userHasUpvotedComment = getUserHasUpvotedComment(comment: comment)
        if userHasUpvotedComment {
            return "hand.thumbsup.fill"
        } else {
            return "hand.thumbsup"
        }
    }

    func getUpvoteUserCountDisplay(comment: Comment) -> String {
        String(comment.upvotedUserIds.count)
    }

    func detachListener() {
        commentService.commentEventDelegate = nil
        self.isLoading = false

        commentService.detachListener()
    }

    func filterSpecificVersionComments() async {
        var versionedComments = allVersionedComments.filter({ $0.0.planVersionNumber == planVersionNumber })

        sortByCreationDateDesc(&versionedComments)

        self.commentOwnerPairs = versionedComments
    }
}

// MARK: - CommentEventDelegate
extension CommentsViewModel: CommentEventDelegate {
    func update(comments: [Comment], errorMessage: String) async {
        print("[CommentsViewModel] Updating Comments")

        guard errorMessage.isEmpty else {
            print("[CommentsViewModel] fetch comments failed in fetchComments()")
            handleError()
            return
        }

        await processComments(comments: comments)

        self.isLoading = false
    }

}

// MARK: PlanEventDelegate
extension CommentsViewModel: PlanEventDelegate {
    func update(plans: [Plan], errorMessage: String) async {
    }

    func update(plan: Plan?, errorMessage: String) async {
        guard let plan = plan else {
            return
        }

        print("[CommentsViewModel] Updating to plan version number \(plan.versionNumber)")

        planVersionNumber = plan.versionNumber
    }
}

// MARK: - Helper Methods
extension CommentsViewModel {
    private func updateCommentUpvotes(comment: Comment, id: String) -> Comment {
        var newComment = comment

        let canEdit = newComment.userId == id

        if newComment.upvotedUserIds.contains(id) {
            newComment.upvotedUserIds = newComment.upvotedUserIds.filter { $0 != id }
            commentPermissions[newComment.id] = (canEdit, false)
        } else {
            newComment.upvotedUserIds.append(id)
            commentPermissions[newComment.id] = (canEdit, true)
        }

        return newComment
    }

    private func updateComment(comment: Comment) async {
        self.isLoading = true

        let (hasUpdated, commentErrorMessage) = await commentService.updateComment(comment: comment)

        guard hasUpdated, commentErrorMessage.isEmpty else {
            print("[CommentViewModel] Update comments failed in updateComment()")
            handleError()
            return
        }

        self.isLoading = false
    }

    private func processComments(comments: [Comment]) async {
        let (currentUser, userErrorMessage) = await userService.getCurrentUser()
        guard let currentUser = currentUser, userErrorMessage.isEmpty else {
            print("[CommentsViewModel] fetch user failed in fetchComments()")
            handleError()
            return
        }

        var seenUsers: [String: User] = [:]
        var fetchedCommentOwnerPairs: [(Comment, User)] = []

        // Update comment permissions, comment owner pairs, and seen users
        for comment in comments {
            let userId = comment.userId
            let canEdit = userId == currentUser.id
            let userHasUpvotedComment = comment.upvotedUserIds.contains(currentUser.id)

            if let user = seenUsers[userId] {
                fetchedCommentOwnerPairs.append((comment, user))
                commentPermissions[comment.id] = (canEdit, userHasUpvotedComment)
                continue
            }

            // fetch user if not seen
            let (user, userErrorMessage) = await userService.getUser(withUserId: userId)

            if !userErrorMessage.isEmpty {
                print("[CommentsViewModel] fetchComments(): User cannot be found, comment will not render")
                continue
            }

            if let user = user {
                fetchedCommentOwnerPairs.append((comment, user))
                commentPermissions[comment.id] = (canEdit, userHasUpvotedComment)
                seenUsers[userId] = user
            }
        }

        sortByCreationDateDesc(&fetchedCommentOwnerPairs)

        self.commentOwnerPairs = fetchedCommentOwnerPairs
        self.allVersionedComments = fetchedCommentOwnerPairs
    }

    private func sortByCreationDateDesc(_ fetchedCommentOwnerPairs: inout [(Comment, User)]) {
        fetchedCommentOwnerPairs.sort {
            $0.0.creationDate > $1.0.creationDate
        }
    }

}

// MARK: - State changes
extension CommentsViewModel {
    private func handleError() {
        self.hasError = true
        self.isLoading = false
    }
}
