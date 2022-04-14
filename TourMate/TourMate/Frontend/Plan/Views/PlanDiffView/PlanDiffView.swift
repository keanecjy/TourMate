//
//  PlanDiffView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct PlanDiffView<T: Plan>: View {
    @Environment(\.dismiss) var dismiss

    var viewModel: PlanViewModel<T>

    private let viewModelFactory: ViewModelFactory

    init(planViewModel: PlanViewModel<T>) {
        self.viewModel = planViewModel
        self.viewModelFactory = ViewModelFactory()
    }

    var body: some View {
        HStack(spacing: 5.0) {
            SimplePlanView(planViewModel: viewModelFactory.copyPlanViewModel(viewModel),
                               initialVersion: viewModel.versionNumber > 1 ?
                               viewModel.versionNumber - 1 : viewModel.versionNumber)

            Divider()

            SimplePlanView(planViewModel: viewModelFactory.copyPlanViewModel(viewModel),
                               initialVersion: viewModel.versionNumber)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
