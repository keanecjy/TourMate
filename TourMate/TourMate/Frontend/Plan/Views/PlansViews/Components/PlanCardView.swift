//
//  PlanCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

@MainActor
struct PlanCardView: View {

    @ObservedObject var plansViewModel: PlansViewModel
    private let viewModelFactory = ViewModelFactory()
    let plan: Plan
    let date: Date
    let planUpvoteViewModel: PlanUpvoteViewModel

    init(plansViewModel: PlansViewModel, plan: Plan, date: Date) {
        self.plansViewModel = plansViewModel
        self.plan = plan
        self.date = date

        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(plan: plan)
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
                PlanUpvoteView(viewModel: planUpvoteViewModel, displayName: false)
                    .frame(maxWidth: UIScreen.screenWidth / 3)
                Spacer()

            }
        }
        .contentShape(Rectangle())
        .onAppear {
            plansViewModel.attachDelegate(planId: plan.id, delegate: planUpvoteViewModel)
        }
        .onDisappear {
            plansViewModel.detachDelegate(planId: plan.id)
        }
    }
}
