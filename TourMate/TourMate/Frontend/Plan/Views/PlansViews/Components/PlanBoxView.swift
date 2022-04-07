//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

struct PlanBoxView: View {

    @StateObject var viewModel: PlanViewModel
    let date: Date

    init(viewModel: PlanViewModel, date: Date) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.date = date
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(viewModel.getShortDurationDescription(date: date))
                    .font(.caption)

                PlanStatusView(status: viewModel.plan.status)
                    .padding([.horizontal])

            }
            Text(viewModel.plan.name)
                .font(.headline)
            if viewModel.plan.status == .proposed {
                UpvotePlanView(viewModel: viewModel, displayName: false)
            }
        }
        .padding()
        .contentShape(Rectangle())
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}
