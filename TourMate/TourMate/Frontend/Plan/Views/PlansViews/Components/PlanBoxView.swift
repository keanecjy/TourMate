//
//  PlanBoxView.swift
//  TourMate
//
//  Created by Rayner Lim on 29/3/22.
//
import SwiftUI

struct PlanBoxView: View {
    let dateFormatter: DateFormatter

    @StateObject var viewModel: PlanViewModel

    init(viewModel: PlanViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = viewModel.plan.startDateTime.timeZone // Takes plan's startDateTime timezone by default
    }

    var startTimeString: String {
        dateFormatter.string(from: viewModel.plan.startDateTime.date)
    }

    var endTimeString: String {
        dateFormatter.string(from: viewModel.plan.endDateTime.date)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(startTimeString).font(.subheadline)
                Text("-").font(.subheadline)
                Text(endTimeString).font(.subheadline)

                PlanStatusView(status: viewModel.plan.status)
                    .padding([.horizontal])

            }
            Text(viewModel.plan.name)
                .font(.headline)
            if viewModel.plan.status == .proposed {
                VStack(alignment: .leading) {
                    UpvotePlanView(viewModel: viewModel, displayName: false)
                }
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
