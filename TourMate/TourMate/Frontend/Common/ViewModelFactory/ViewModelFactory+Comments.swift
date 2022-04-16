//
//  ViewModelFactory+Comments.swift
//  TourMate
//
//  Created by Terence Ho on 14/4/22.
//

import Foundation

extension ViewModelFactory {
    // Comments
    func getCommentsViewModel<T: Plan>(planViewModel: PlanViewModel<T>) -> CommentsViewModel {
        getCommentsViewModel(plan: planViewModel.plan)
    }

    func getCommentsViewModel(plan: Plan) -> CommentsViewModel {
        CommentsViewModel(planId: plan.id, planVersionNumber: plan.versionNumber,
                          commentService: commentService.copy(), userService: userService)
    }

    func getAddCommentViewModel(commentsViewModel: CommentsViewModel) -> AddCommentViewModel {
        AddCommentViewModel(planId: commentsViewModel.planId,
                            planVersionNumber: commentsViewModel.planVersionNumber,
                            commentService: commentService.copy(),
                            userService: userService)
    }
}
