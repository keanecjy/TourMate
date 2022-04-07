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
                    Text(viewModel.shortDurationDescriptionDisplay)
                        .font(.caption)

                    PlanStatusView(status: viewModel.statusDisplay)
                        .padding([.horizontal])
                }
                Text(viewModel.nameDisplay)
                    .font(.headline)
            }
            .padding()

            Spacer()

            VStack {
                Spacer()
                UpvotePlanView(viewModel: viewModel, displayName: false)
                    .frame(maxWidth: UIScreen.screenWidth / 3)
                Spacer()

            }
        }
        .contentShape(Rectangle())
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}
