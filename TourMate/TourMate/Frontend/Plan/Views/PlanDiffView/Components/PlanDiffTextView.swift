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

    init(planDiffMap: PlanDiffMap, wordLimit: Int = 80) {
        self.planDiffMap = planDiffMap
        self.wordLimit = wordLimit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            ForEach(planDiffMap.sorted(by: { $0.key > $1.key }), id: \.key) { field, change in
                HStack(spacing: 0.0) {
                    Text("> ").bold()

                    Text(field).bold()

                    Text(" changed").bold()

                    if (change.0.count + change.1.count) < wordLimit {
                        Text(" from ").bold()

                        Text(change.0).italic().bold()

                        Text(" to ").bold()

                        Text(change.1).italic().bold()
                    }
                }
                .opacity(0.6)
            }
        }
    }
}
