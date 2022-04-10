//
//  PlanHeaderView.swift
//  TourMate
//
//  Created by Keane Chan on 7/4/22.
//

import SwiftUI

struct PlanHeaderView: View {

    let planName: String
    let planStatus: PlanStatus
    let planOwner: User
    let creationDateDisplay: String
    let lastModifiedDateDisplay: String
    let versionNumberDisplay: String

    var body: some View {
        HStack(spacing: 10.0) {
            Text(planName)
                .font(.largeTitle)
                .bold()

            PlanStatusView(status: planStatus)

            Spacer()

            VStack(alignment: .leading, spacing: 5.0) {
                Text("Created by: \(planOwner.name)")

                Text("Creation date: \(creationDateDisplay)")

                Text("Last modified: \(lastModifiedDateDisplay)")

                Text("Version Number: \(versionNumberDisplay)")
            }
        }
    }
}
