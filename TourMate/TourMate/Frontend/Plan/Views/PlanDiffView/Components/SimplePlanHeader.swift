//
//  SimplePlanHeader.swift
//  TourMate
//
//  Created by Keane Chan on 16/4/22.
//

import SwiftUI

struct SimplePlanHeader: View {

    let name: String
    let status: PlanStatus

    var body: some View {
        HStack(spacing: 10.0) {
            Text(name).font(.title).bold()

            PlanStatusView(status: status)
        }
    }
}
