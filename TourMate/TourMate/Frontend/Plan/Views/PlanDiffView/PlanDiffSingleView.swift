//
//  PlanDiffSingleView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

@MainActor
struct PlanDiffSingleView<T: Plan>: View {
    @StateObject var viewModel: PlanViewModel<T>

    @State private var selectedVersion: Int

    init(planViewModel: PlanViewModel<T>, initialVersion: Int) {
        self._viewModel = StateObject(wrappedValue: planViewModel)
        self._selectedVersion = State(initialValue: initialVersion)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 30.0) {
            Picker("Version", selection: $selectedVersion) {
                ForEach(viewModel.allVersionNumbers, id: \.self) { num in
                    Text("Version: \(String(num))").tag(num)
                }
            }
            .pickerStyle(.menu)
            .padding([.horizontal])
            .background(
                Capsule().fill(Color.primary.opacity(0.25))
            )
            .onChange(of: selectedVersion, perform: { val in
                Task {
                    await viewModel.setVersionNumber(val)
                }
            })

            SimplePlanView(planViewModel: viewModel)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.setVersionNumber(selectedVersion)
        }
    }
}
