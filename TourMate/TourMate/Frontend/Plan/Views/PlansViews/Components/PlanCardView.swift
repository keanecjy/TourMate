//
//  PlanCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlanCardView: View {

    @StateObject var viewModel: PlanViewModel

    init(viewModel: PlanViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(viewModel.shortDurationDescription)
                        .font(.caption)

                    PlanStatusView(status: viewModel.plan.status)
                        .padding([.horizontal])

                }
                Text(viewModel.plan.name)
                    .font(.headline)
            }
            .padding()

            Spacer()

            if viewModel.plan.status == .proposed {
                UpvotePlanView(viewModel: viewModel, displayName: false)
                    .frame(width: 240)
            }
        }
        .contentShape(Rectangle())
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}
