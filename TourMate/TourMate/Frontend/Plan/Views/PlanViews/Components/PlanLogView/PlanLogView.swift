//
//  PlanLogView.swift
//  TourMate
//
//  Created by Terence Ho on 15/4/22.
//

import SwiftUI

struct PlanLogView<T: Plan>: View {

    private let viewModelFactory: ViewModelFactory
    private let viewFactory: ViewFactory

    @ObservedObject var planDisplayViewModel: PlanDisplayViewModel<T>
    @ObservedObject var commentsViewModel: CommentsViewModel
    @ObservedObject var planUpvoteViewModel: PlanUpvoteViewModel
    let addCommentViewModel: AddCommentViewModel

    init(planDisplayViewModel: PlanDisplayViewModel<T>,
         commentsViewModel: CommentsViewModel,
         planUpvoteViewModel: PlanUpvoteViewModel) {

        self.viewModelFactory = ViewModelFactory()
        self.viewFactory = ViewFactory()

        self.planDisplayViewModel = planDisplayViewModel
        self.commentsViewModel = commentsViewModel
        self.planUpvoteViewModel = planUpvoteViewModel
        self.addCommentViewModel = viewModelFactory.getAddCommentViewModel(commentsViewModel: commentsViewModel)
    }

    var body: some View {
        ActionableContentView { // content
            ScrollableContentView {
                PlanLogListView(planDisplayViewModel: planDisplayViewModel,
                                commentsViewModel: commentsViewModel,
                                planUpvoteViewModel: planUpvoteViewModel)
            }
        } actionContent: {
            if commentsViewModel.allowUserInteraction {
                AddCommentView(viewModel: addCommentViewModel)
            }
        }
        .task {
            commentsViewModel.attachDelegate(delegate: addCommentViewModel)
            await commentsViewModel.fetchCommentsAndListen()
        }
        .onDisappear {
            commentsViewModel.detachDelegates()
            commentsViewModel.detachListener()
        }
    }
}

// struct PlanLogView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanLogView()
//    }
// }
