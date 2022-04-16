//
//  PlanDiffView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct PlanDiffView<T: Plan>: View {
    var viewModel: PlanViewModel<T>

    init(planViewModel: PlanViewModel<T>) {
        self.viewModel = planViewModel
    }

    var body: some View {
        HStack(spacing: 5.0) {
            SimplePlanView(planViewModel: viewModel.copy(),
                           initialVersion: viewModel.versionNumber > 1 ?
                           viewModel.versionNumber - 1 : viewModel.versionNumber)

            Divider()

            SimplePlanView(planViewModel: viewModel.copy(),
                           initialVersion: viewModel.versionNumber)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
