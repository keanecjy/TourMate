//
//  PlanDiffView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct PlanDiffView<T: Plan>: View {
    @StateObject var leftViewModel: PlanViewModel<T>
    @StateObject var rightViewModel: PlanViewModel<T>

    @State private var leftVersion: Int
    @State private var rightVersion: Int

    let planDiffUtil: PlanDiffUtil

    init(planViewModel: PlanViewModel<T>) {
        let currentVersion = planViewModel.versionNumber

        self._leftVersion = State(wrappedValue: planViewModel.isLatest ? currentVersion : currentVersion - 1)
        self._rightVersion = State(wrappedValue: planViewModel.versionNumber)

        self._leftViewModel = StateObject(wrappedValue: planViewModel.copy())
        self._rightViewModel = StateObject(wrappedValue: planViewModel.copy())

        self.planDiffUtil = PlanDiffUtil(wordLimit: Int.max)
    }

    var body: some View {
        ScrollView {
            VStack {

                HStack(spacing: 5.0) {
                    SimplePlanView(planViewModel: leftViewModel,
                                   initialVersion: $leftVersion)

                    Divider()

                    SimplePlanView(planViewModel: rightViewModel,
                                   initialVersion: $rightVersion)
                }

                Text(planDiffUtil.getDiff(plan1: leftViewModel.plan, plan2: rightViewModel.plan))

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
