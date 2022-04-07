//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

struct PlanBoxView: View {

    @StateObject var viewModel: PlanViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    let date: Date

    init(viewModel: PlanViewModel, date: Date) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.planUpvoteViewModel = ViewModelFactory.getPlanUpvoteViewModel(planViewModel: viewModel)
        self.date = date
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(viewModel.getShortDurationDescription(date: date))
                    .font(.caption)

                PlanStatusView(status: viewModel.statusDisplay)
                    .padding([.horizontal])
            }
            Text(viewModel.nameDisplay)
                .font(.headline)
            UpvotePlanView(viewModel: planUpvoteViewModel, displayName: false)
        }
        .padding()
        .contentShape(Rectangle())
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}
