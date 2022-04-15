//
//  SimplePlanModifierView.swift
//  TourMate
//
//  Created by Keane Chan on 14/4/22.
//

import SwiftUI

struct SimplePlanModifierView: View {
    var planOwner: User
    var planLastModifier: User

    var body: some View {
        VStack(alignment: .leading) {
            Text("Created by: \(planOwner.name)")
                .font(.footnote)

            Text("Modified by: \(planLastModifier.name)")
                .font(.footnote)
        }
    }
}
