//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

struct PlanBoxView: View {

    @StateObject var viewModel: PlanViewModel

    init(viewModel: PlanViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(viewModel.shortDurationDescriptionDisplay)
                    .font(.caption)

                PlanStatusView(status: viewModel.statusDisplay)
                    .padding([.horizontal])
            }
            Text(viewModel.nameDisplay)
                .font(.headline)
            UpvotePlanView(viewModel: viewModel, displayName: false)
        }
        .padding()
        .contentShape(Rectangle())
        .task {
            await viewModel.fetchPlanAndListen()
        }
        .onDisappear(perform: { () in viewModel.detachListener() })
    }
}
