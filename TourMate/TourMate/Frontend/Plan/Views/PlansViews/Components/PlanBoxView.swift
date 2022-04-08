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
    let planName: String
    let planStatus: PlanStatus
    let startDateTime: DateTime
    let endDateTime: DateTime
    let date: Date

    init(planUpvoteViewModel: PlanUpvoteViewModel, planName: String,
         planStatus: PlanStatus, startDateTime: DateTime, endDateTime: DateTime,
         date: date) {
        self.planUpvoteViewModel = planUpvoteViewModel
        self.planName = planName
        self.planStatus = planStatus
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.date = date
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
            // TO Use date
                Text(DateUtil.shortDurationDesc(from: startDateTime, to: endDateTime))
                    .font(.caption)

                PlanStatusView(status: planStatus)
                    .padding([.horizontal])
            }
            Text(planName)
                .font(.headline)
            UpvotePlanView(viewModel: planUpvoteViewModel, displayName: false)
        }
        .padding()
        .contentShape(Rectangle())
    }
}
