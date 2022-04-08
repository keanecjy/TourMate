//
//  PlanCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

@MainActor
struct PlanCardView: View {

    let planUpvoteViewModel: PlanUpvoteViewModel
    let plan: Plan
    let date: Date

    init(planUpvoteViewModel: PlanUpvoteViewModel, plan: Plan, date: Date) {
        self.planUpvoteViewModel = planUpvoteViewModel
        self.plan = plan
        self.date = date
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(DateUtil.shortDurationDesc(from: plan.startDateTime, to: plan.endDateTime, on: date))
                        .font(.caption)

                    PlanStatusView(status: plan.status)
                        .padding([.horizontal])
                }
                Text(plan.name)
                    .font(.headline)
            }
            .padding()

            Spacer()

            VStack {
                Spacer()
                UpvotePlanView(viewModel: planUpvoteViewModel, displayName: false)
                    .frame(maxWidth: UIScreen.screenWidth / 3)
                Spacer()

            }
        }
        .contentShape(Rectangle())
    }
}
