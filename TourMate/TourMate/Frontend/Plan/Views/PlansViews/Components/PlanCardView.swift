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
    let planName: String
    let planStatus: PlanStatus
    let startDateTime: DateTime
    let endDateTime: DateTime
    let date: Date

    init(planId: String, planName: String, planStatus: PlanStatus, startDateTime: DateTime, endDateTime: DateTime, date: Date) {
        self.planUpvoteViewModel = ViewModelFactory.getPlanUpvoteViewModel(planId: planId)
        self.planName = planName
        self.planStatus = planStatus
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.date = date
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(DateUtil.shortDurationDesc(from: startDateTime, to: endDateTime))
                        .font(.caption)

                    PlanStatusView(status: planStatus)
                        .padding([.horizontal])
                }
                Text(planName)
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
