//
//  PlanCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlanCardView: View {

    @StateObject var viewModel: PlanViewModel
    let date: Date

    init(viewModel: PlanViewModel, date: Date) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.date = date
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(viewModel.getShortDurationDescription(date: date))
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
                VStack {
                    Spacer()
                    UpvotePlanView(viewModel: viewModel, displayName: false)
                        .frame(maxWidth: UIScreen.screenWidth / 3)
                    Spacer()

                }
            }
        }
        .contentShape(Rectangle())
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}
