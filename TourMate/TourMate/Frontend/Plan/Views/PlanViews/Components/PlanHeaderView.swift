//
//  PlanHeaderView.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import SwiftUI

struct PlanHeaderView<TitleView: View>: View {
    let title: TitleView
    let planStatus: PlanStatus
    let planOwner: User
    let creationDateDisplay: String
    let lastModifier: User
    let lastModifiedDateDisplay: String
    let versionNumberDisplay: String

    init(planStatus: PlanStatus, planOwner: User, creationDateDisplay: String, lastModifier: User,
         lastModifiedDateDisplay: String, versionNumberDisplay: String, @ViewBuilder title: () -> TitleView) {
        self.planStatus = planStatus
        self.planOwner = planOwner
        self.creationDateDisplay = creationDateDisplay
        self.lastModifier = lastModifier
        self.lastModifiedDateDisplay = lastModifiedDateDisplay
        self.versionNumberDisplay = versionNumberDisplay
        self.title = title()
    }

    var body: some View {
        HStack(spacing: 10.0) {
            title
                .font(.largeTitle)

            PlanStatusView(status: planStatus)

            Spacer()

            VStack(alignment: .leading, spacing: 5.0) {
                Text("Created by: \(planOwner.name)")
                    .font(.callout)

                Text("Creation date: \(creationDateDisplay)")
                    .font(.callout)

                Text("Last modified by: \(lastModifier.name)")
                    .font(.callout)

                Text("Last modified: \(lastModifiedDateDisplay)")
                    .font(.callout)

                Text("Version: \(versionNumberDisplay)")
                    .font(.callout)
            }
        }
    }
}
