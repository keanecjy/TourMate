//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

@MainActor
struct PlanBoxView: View {

    let planUpvoteViewModel: PlanUpvoteViewModel
    let plan: Plan
    let date: Date

    init(planUpvoteViewModel: PlanUpvoteViewModel, plan: Plan, date: Date) {
        self.planUpvoteViewModel = planUpvoteViewModel
        self.plan = plan
        self.date = date
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(DateUtil.shortDurationDesc(from: plan.startDateTime, to: plan.endDateTime, on: date))
                    .font(.caption)

                PlanStatusView(status: plan.status)
                    .padding([.horizontal])
            }
            Text(plan.name)
                .font(.headline)
            PlanUpvoteView(viewModel: planUpvoteViewModel, displayName: false)
        }
        .padding()
        .contentShape(Rectangle())
    }
}
