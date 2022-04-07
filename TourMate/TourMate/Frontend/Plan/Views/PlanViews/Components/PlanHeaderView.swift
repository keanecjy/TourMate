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

    var body: some View {
        HStack(spacing: 10.0) {
            Text(planName)
                .font(.largeTitle)
                .bold()

            Spacer()

            PlanStatusView(status: planStatus)

            UserIconView(imageUrl: planOwner.imageUrl, name: planOwner.name, displayName: false)
        }
    }
}
