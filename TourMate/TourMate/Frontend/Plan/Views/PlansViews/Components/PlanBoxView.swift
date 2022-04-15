//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

@MainActor
struct PlanBoxView: View {

    @ObservedObject var plansViewModel: PlansViewModel
    @StateObject var commentsViewModel: CommentsViewModel

    let planUpvoteViewModel: PlanUpvoteViewModel

    let plan: Plan
    let date: Date

    init(plansViewModel: PlansViewModel, plan: Plan, date: Date) {
        self.plansViewModel = plansViewModel
        self.plan = plan
        self.date = date

        let viewModelFactory = ViewModelFactory()
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(plan: plan)

        let commentsViewModel = viewModelFactory.getCommentsViewModel(plan: plan)
        self._commentsViewModel = StateObject(wrappedValue: commentsViewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            HStack(spacing: 10.0) {
                Text(DateUtil.shortDurationDesc(from: plan.startDateTime, to: plan.endDateTime, on: date))
                    .font(.caption)

                PlanStatusView(status: plan.status)

            }

            Text(plan.name)
                .font(.headline)

            HStack(spacing: 10.0) {

                HStack(spacing: 5.0) {
                    Image(systemName: "text.bubble.fill")

                    Text(String(commentsViewModel.commentCount))
                }

                Text("(v\(String(plan.versionNumber)))")
                    .font(.caption)
            }

            PlanUpvoteView(viewModel: planUpvoteViewModel, displayName: false)
        }
        .padding()
        .contentShape(Rectangle())
        .onAppear {
            plansViewModel.attachDelegate(planId: plan.id, delegate: planUpvoteViewModel)

            Task {
                await commentsViewModel.fetchCommentsAndListen()
            }
        }
        .onDisappear {
            plansViewModel.detachDelegate(planId: plan.id)
            commentsViewModel.detachListener()
        }
    }
}
