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
    let planUpvoteViewModel: PlanUpvoteViewModel
    private let viewModelFactory = ViewModelFactory()
    let plan: Plan
    let date: Date

    init(plansViewModel: PlansViewModel, plan: Plan, date: Date) {
        self.plansViewModel = plansViewModel
        self.plan = plan
        self.date = date

        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(plan: plan)
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
        .onAppear {
            plansViewModel.attachDelegate(planId: plan.id, delegate: planUpvoteViewModel)
        }
        .onDisappear {
            plansViewModel.detachDelegate(planId: plan.id)
        }
    }
}
