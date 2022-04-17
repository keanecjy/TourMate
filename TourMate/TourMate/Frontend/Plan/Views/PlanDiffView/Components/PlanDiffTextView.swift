//
//  PlanDiffTextView.swift
//  TourMate
//
//  Created by Keane Chan on 16/4/22.
//

import SwiftUI

struct PlanDiffTextView: View {
    let planDiffMap: PlanDiffMap
    let wordLimit: Int
    let spacing: Double

    init(planDiffMap: PlanDiffMap, spacing: Double = 2.0, wordLimit: Int = 200) {
        self.planDiffMap = planDiffMap
        self.spacing = spacing
        self.wordLimit = wordLimit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            if planDiffMap.isEmpty {
                Text("There are no changes between these versions")
            } else {
                ForEach(planDiffMap.sorted(by: { $0.key > $1.key }), id: \.key) { field, change in
                    HStack(spacing: 0.0) {
                        Text("> ").bold()

                        Text(field).bold()

                        if (change.0.count + change.1.count) < wordLimit {
                            Text(": ").bold()

                            Text(change.0).italic().bold()

                            Text(" -> ").bold()

                            Text(change.1).italic().bold()
                        }
                    }
                    .opacity(0.6)
                }
            }
        }
    }
}
