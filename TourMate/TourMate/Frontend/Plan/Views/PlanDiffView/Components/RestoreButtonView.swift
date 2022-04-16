//
//  RestoreButtonView.swift
//  TourMate
//
//  Created by Keane Chan on 16/4/22.
//

import SwiftUI

struct RestoreButtonView<T: Plan>: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var planViewModel: PlanViewModel<T>

    var body: some View {
        if !planViewModel.isLatest {
            Button {
                Task {
                    await planViewModel.restoreToCurrentVersion()
                    dismiss()
                }
            } label: {
                Text("Restore")
                    .font(.caption)
                    .bold()
                    .padding(5.0)
                    .foregroundColor(.primary)
                    .colorInvert()
                    .background(Color.primary.opacity(0.25))
                    .cornerRadius(20.0)
            }
        }
    }
}
